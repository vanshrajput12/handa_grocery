import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets.dart';
import '../services/cart_service.dart';
import 'checkout_page.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartService cartService = CartService();

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amberSoft = Color(0xFFFFF4D6);
  static const amberText = Color(0xFF9A6B00);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cartService,
      builder: (context, _) {
        final items = cartService.items;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F6),
          body: Column(
            children: [
              _buildHeader(context, cartService.itemCount),

              Expanded(
                child: items.isEmpty
                    ? _emptyCart(context)
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  // items + 1 extra row for the "Continue Shopping" button
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return _continueShoppingOutlined(context);
                    }
                    return _cartItemCard(items[index]);
                  },
                ),
              ),

              if (items.isNotEmpty) _buildSummary(context),
            ],
          ),
        );
      },
    );
  }

  // Safe "go back to shopping": only pops when there is a page to go back to
  void _continueShopping(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  // ================= GREEN CURVED HEADER =================
  Widget _buildHeader(BuildContext context, int itemCount) {
    final bool canPop = Navigator.of(context).canPop();

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
              if (canPop) ...[
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
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Cart",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      itemCount == 0
                          ? "Nothing here yet"
                          : "$itemCount ${itemCount == 1 ? "item" : "items"} ready for checkout",
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
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CART ITEM CARD (swipe left to remove) =================
  Widget _cartItemCard(dynamic item) {
    final double lineTotal = (item.unitPrice * item.quantity).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Dismissible(
        key: ValueKey(item.product.text),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => cartService.removeFromCart(item.product.text),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
              const SizedBox(height: 2),
              Text(
                "Remove",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEDF3EE)),
            boxShadow: [
              BoxShadow(
                color: green.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // PRODUCT IMAGE
              Container(
                width: 92,
                height: 92,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF1F8F2), Color(0xFFE3F1E6)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ProductImage(path: item.product.image, fit: BoxFit.cover),
              ),

              const SizedBox(width: 12),

              // PRODUCT INFORMATION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME + DELETE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.product.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: darkText,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            cartService.removeFromCart(item.product.text);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "₹${item.unitPrice.toStringAsFixed(0)} each",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // QUANTITY PILL + LINE TOTAL
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _quantityButton(
                                icon: Icons.remove_rounded,
                                onTap: () {
                                  cartService.decreaseQuantity(
                                    item.product.text,
                                  );
                                },
                              ),
                              SizedBox(
                                width: 26,
                                child: Center(
                                  child: Text(
                                    "${item.quantity}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: darkText,
                                    ),
                                  ),
                                ),
                              ),
                              _quantityButton(
                                icon: Icons.add_rounded,
                                onTap: () {
                                  cartService.increaseQuantity(
                                    item.product.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₹${lineTotal.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CONTINUE SHOPPING (below the items) =================
  Widget _continueShoppingOutlined(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 6),
      child: SizedBox(
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _continueShopping(context),
          icon: const Icon(Icons.add_shopping_cart_rounded, size: 19),
          label: Text(
            "Add more items",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: green,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFBFE0C9), width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  // ================= BOTTOM SUMMARY =================
  Widget _buildSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow(
              icon: Icons.shopping_bag_outlined,
              label: "Total Items",
              value: "${cartService.itemCount}",
            ),

            const SizedBox(height: 10),

            _summaryRow(
              icon: Icons.local_shipping_outlined,
              label: "Delivery",
              value: "Calculated at checkout",
            ),

            const SizedBox(height: 14),

            // TOTAL BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD7EBDD)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                  ),
                  Text(
                    "₹${cartService.totalAmount.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // CHECKOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Proceed to Checkout",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17, color: green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // ================= EMPTY CART =================
  Widget _emptyCart(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // layered illustration
            SizedBox(
              height: 170,
              width: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGreen.withValues(alpha: 0.6),
                    ),
                  ),
                  Container(
                    height: 124,
                    width: 124,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGreen,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 58,
                      color: green,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 18,
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: amberSoft,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        size: 18,
                        color: amberText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Text(
              "Your cart is empty",
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add some fresh groceries to your cart\nand they will appear here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.6,
                color: Colors.grey.shade600,
              ),
            ),

            if (canPop) ...[
              const SizedBox(height: 28),

              // CONTINUE SHOPPING
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _continueShopping(context),
                  icon: const Icon(Icons.storefront_outlined, size: 20),
                  label: Text(
                    "Continue Shopping",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18, color: green),
      ),
    );
  }
}