import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../UiHelper/checkoutpage_textfield_helper.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'order_success.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService cartService = CartService();
  final OrderService orderService = OrderService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amberSoft = Color(0xFFFFF4D6);
  static const amberText = Color(0xFF9A6B00);

  String selectedPaymentMethod = "Cash on Delivery";

  bool isPlacingOrder = false;
  bool isLoadingAddress = true;

  @override
  void initState() {
    super.initState();

    // Load the user's previously saved address.
    _loadSavedAddress();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOAD SAVED ADDRESS
  // ============================================================

  Future<void> _loadSavedAddress() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }

      return;
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> document =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('checkoutAddress')
              .doc('current')
              .get();

      if (!document.exists) {
        if (mounted) {
          setState(() {
            isLoadingAddress = false;
          });
        }

        return;
      }

      final Map<String, dynamic>? data = document.data();

      if (data == null) {
        if (mounted) {
          setState(() {
            isLoadingAddress = false;
          });
        }

        return;
      }

      nameController.text = data['name']?.toString() ?? '';
      phoneController.text = data['phone']?.toString() ?? '';
      addressController.text = data['address']?.toString() ?? '';
      cityController.text = data['city']?.toString() ?? '';
      stateController.text = data['state']?.toString() ?? '';
      pincodeController.text = data['pincode']?.toString() ?? '';

      debugPrint('Saved address loaded successfully.');
    } catch (e) {
      debugPrint('Error loading saved address: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  // ============================================================
  // SAVE / UPDATE ADDRESS
  // ============================================================

  Future<void> _saveAddress() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('User is not logged in. Address was not saved.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('checkoutAddress')
          .doc('current')
          .set({
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'address': addressController.text.trim(),
            'city': cityController.text.trim(),
            'state': stateController.text.trim(),
            'pincode': pincodeController.text.trim(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      debugPrint('Address saved/updated successfully.');
    } catch (e) {
      debugPrint('Error saving address: $e');

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = cartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================================================
                    // DELIVERY ADDRESS
                    // ======================================================
                    _sectionTitle(
                      icon: Icons.location_on_outlined,
                      title: "Delivery Address",
                      subtitle: "Where should we deliver?",
                    ),

                    const SizedBox(height: 12),

                    _card(
                      child: Column(
                        children: [
                          if (isLoadingAddress)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: green,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Loading saved address...",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // NAME
                          CheckOutpageTextFieldHelper(
                            controller: nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // PHONE
                          CheckOutpageTextFieldHelper(
                            controller: phoneController,
                            label: "Phone Number",
                            hint: "Enter 10-digit phone number",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter phone number";
                              }

                              if (value.trim().length != 10) {
                                return "Enter a valid 10-digit number";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // ADDRESS
                          CheckOutpageTextFieldHelper(
                            controller: addressController,
                            label: "Address",
                            hint: "House no., street, area",
                            icon: Icons.home_outlined,
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your address";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // CITY + STATE (side by side)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CheckOutpageTextFieldHelper(
                                  controller: cityController,
                                  label: "City",
                                  hint: "Your city",
                                  icon: Icons.location_city_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Enter city";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CheckOutpageTextFieldHelper(
                                  controller: stateController,
                                  label: "State",
                                  hint: "Your state",
                                  icon: Icons.map_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Enter state";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // PINCODE
                          CheckOutpageTextFieldHelper(
                            controller: pincodeController,
                            label: "Pincode",
                            hint: "Enter 6-digit pincode",
                            icon: Icons.pin_drop_outlined,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter pincode";
                              }

                              if (value.trim().length != 6) {
                                return "Enter a valid 6-digit pincode";
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ======================================================
                    // PAYMENT METHOD
                    // ======================================================
                    _sectionTitle(
                      icon: Icons.payment_outlined,
                      title: "Payment Method",
                      subtitle: "Choose how you'd like to pay",
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: green, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.local_atm_rounded,
                              color: green,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedPaymentMethod,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: darkText,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Pay when your order is delivered",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: green,
                            size: 26,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ======================================================
                    // ORDER SUMMARY
                    // ======================================================
                    _sectionTitle(
                      icon: Icons.shopping_bag_outlined,
                      title: "Order Summary",
                      subtitle:
                          "${cartService.itemCount} ${cartService.itemCount == 1 ? "item" : "items"} in your order",
                    ),

                    const SizedBox(height: 12),

                    _card(
                      child: Column(
                        children: [
                          ...items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFF1F8F2),
                                          Color(0xFFE3F1E6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.asset(
                                      item.product.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Color(0xFFB6C8B9),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.text,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: darkText,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: lightGreen,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "Qty ${item.quantity}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "₹${item.totalPrice.toStringAsFixed(0)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: darkText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const Divider(color: Color(0xFFEDF1ED)),

                          const SizedBox(height: 8),

                          _priceRow(
                            "Items",
                            "₹${cartService.totalAmount.toStringAsFixed(0)}",
                          ),

                          const SizedBox(height: 8),

                          _priceRow("Delivery", "FREE", valueColor: green),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreen,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD7EBDD),
                              ),
                            ),
                            child: _priceRow(
                              "Total",
                              "₹${cartService.totalAmount.toStringAsFixed(0)}",
                              isTotal: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ======================================================
                    // COD INFORMATION
                    // ======================================================
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: amberSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: amberText,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Please keep the exact order amount ready when your order is delivered.",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                height: 1.5,
                                color: const Color(0xFF6B5A2A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ============================================================
            // PLACE ORDER BAR
            // ============================================================
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: green.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isPlacingOrder || items.isEmpty
                        ? null
                        : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: isPlacingOrder
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 21,
                              ),
                              const SizedBox(width: 9),
                              Text(
                                "Place Order • ₹${cartService.totalAmount.toStringAsFixed(0)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GREEN CURVED HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepGreen, green],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Row(
            children: [
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const SizedBox(
                    height: 44,
                    width: 44,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: darkText,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Checkout",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Almost there! Confirm your details",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (cartService.items.isEmpty) {
      _showMessage("Your cart is empty");
      return;
    }

    _showOrderConfirmation();
  }

  // ============================================================
  // CONFIRMATION BOTTOM SHEET
  // ============================================================

  void _showOrderConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 25, 22, 25),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 36,
                    color: green,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Confirm Your Order",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Your order will be placed with Cash on Delivery.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE3EEE5)),
                  ),
                  child: Column(
                    children: [
                      _confirmationRow("Payment", "Cash on Delivery"),
                      const SizedBox(height: 8),
                      _confirmationRow(
                        "Total",
                        "₹${cartService.totalAmount.toStringAsFixed(0)}",
                        highlight: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: green,
                          side: const BorderSide(color: Color(0xFFBFE0C9)),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await _saveOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Confirm Order",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SAVE ORDER
  // ============================================================

  Future<void> _saveOrder() async {
    if (isPlacingOrder) {
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    try {
      // FIRST: SAVE ORDER
      final String orderId = await orderService.placeOrder(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        paymentMethod: selectedPaymentMethod,
      );

      // SECOND: SAVE / UPDATE ADDRESS
      await _saveAddress();

      // THIRD: CLEAR CART
      cartService.clearCart();

      if (!mounted) {
        return;
      }

      // FOURTH: GO TO SUCCESS SCREEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId)),
      );
    } catch (e) {
      debugPrint("Order error: $e");

      if (!mounted) {
        return;
      }

      _showMessage("Could not place order. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  // ============================================================
  // WHITE CARD
  // ============================================================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDF3EE)),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: green, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _priceRow(
    String title,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? darkText : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 20 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? (isTotal ? green : darkText),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONFIRMATION ROW
  // ============================================================

  Widget _confirmationRow(
    String title,
    String value, {
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: highlight ? 14 : 12,
            fontWeight: FontWeight.w700,
            color: highlight ? green : darkText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        backgroundColor: green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
