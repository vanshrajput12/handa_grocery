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
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "CHECKOUT",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Form(
        key: _formKey,

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ======================================================
                    // DELIVERY ADDRESS
                    // ======================================================

                    _sectionTitle(
                      icon: Icons.location_on_outlined,
                      title: "Delivery Address",
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          if (isLoadingAddress)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),

                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,

                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.amber.shade800,
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

                          // CITY
                          CheckOutpageTextFieldHelper(
                            controller: cityController,
                            label: "City",
                            hint: "Enter your city",
                            icon: Icons.location_city_outlined,

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your city";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // STATE
                          CheckOutpageTextFieldHelper(
                            controller: stateController,
                            label: "State",
                            hint: "Enter your state",
                            icon: Icons.map_outlined,

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your state";
                              }

                              return null;
                            },
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

                    const SizedBox(height: 25),

                    // ======================================================
                    // PAYMENT METHOD
                    // ======================================================

                    _sectionTitle(
                      icon: Icons.payment_outlined,
                      title: "Payment Method",
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: Colors.amber.shade300,
                          width: 1.2,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,

                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: Icon(
                              Icons.local_atm_rounded,
                              color: Colors.amber.shade800,
                              size: 25,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Cash on Delivery",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
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

                          Radio<String>(
                            value: "Cash on Delivery",
                            groupValue: selectedPaymentMethod,
                            activeColor: Colors.amber.shade800,

                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                selectedPaymentMethod = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ======================================================
                    // ORDER SUMMARY
                    // ======================================================

                    _sectionTitle(
                      icon: Icons.shopping_bag_outlined,
                      title: "Order Summary",
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        children: [
                          ...items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),

                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    padding: const EdgeInsets.all(6),

                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Image.asset(
                                      item.product.image,
                                      fit: BoxFit.contain,

                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons
                                              .image_not_supported_outlined,
                                          color: Colors.grey,
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
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          "Qty: ${item.quantity}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
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
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 10),

                          _priceRow(
                            "Items",
                            "₹${cartService.totalAmount.toStringAsFixed(0)}",
                          ),

                          const SizedBox(height: 8),

                          _priceRow(
                            "Delivery",
                            "FREE",
                            valueColor: Colors.green.shade700,
                          ),

                          const SizedBox(height: 10),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 10),

                          _priceRow(
                            "Total",
                            "₹${cartService.totalAmount.toStringAsFixed(0)}",
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ======================================================
                    // COD INFORMATION
                    // ======================================================

                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.amber.shade800,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Please keep the exact order amount ready when your order is delivered.",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                height: 1.5,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ============================================================
            // PLACE ORDER BUTTON
            // ============================================================

            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
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
                      backgroundColor: Colors.black,
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
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
                  width: 70,
                  height: 70,

                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 35,
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Confirm Your Order",

                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
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
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    children: [
                      _confirmationRow(
                        "Payment",
                        "Cash on Delivery",
                      ),

                      const SizedBox(height: 8),

                      _confirmationRow(
                        "Total",
                        "₹${cartService.totalAmount.toStringAsFixed(0)}",
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
                          foregroundColor: Colors.black,

                          side: const BorderSide(
                            color: Colors.black12,
                          ),

                          minimumSize: const Size(
                            double.infinity,
                            52,
                          ),

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
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,

                          minimumSize: const Size(
                            double.infinity,
                            52,
                          ),

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
      // ----------------------------------------------------------
      // FIRST: SAVE ORDER
      // ----------------------------------------------------------

      final String orderId = await orderService.placeOrder(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        paymentMethod: selectedPaymentMethod,
      );

      // ----------------------------------------------------------
      // SECOND: SAVE / UPDATE ADDRESS
      //
      // If the address already exists:
      //     OLD ADDRESS -> NEW ADDRESS
      //
      // If it doesn't exist:
      //     CREATE ADDRESS
      // ----------------------------------------------------------

      await _saveAddress();

      // ----------------------------------------------------------
      // THIRD: CLEAR CART
      // ----------------------------------------------------------

      cartService.clearCart();

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // FOURTH: GO TO SUCCESS SCREEN
      // ----------------------------------------------------------

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            orderId: orderId,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Order error: $e");

      if (!mounted) {
        return;
      }

      _showMessage(
        "Could not place order. Please try again.",
      );
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            color: Colors.amber.shade800,
            size: 21,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,

          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
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
            fontWeight: isTotal
                ? FontWeight.w700
                : FontWeight.w500,
            color: isTotal
                ? Colors.black
                : Colors.grey.shade600,
          ),
        ),

        Text(
          value,

          style: GoogleFonts.poppins(
            fontSize: isTotal ? 19 : 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.black,
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
      String value,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),

        Text(
          value,

          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
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

          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        backgroundColor: Colors.black,

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(15),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}