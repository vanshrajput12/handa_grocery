import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/bottom%20Nav/Bottom_Nav.dart';
import 'order_detail_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),

                child: Column(
                  children: [
                    const SizedBox(height: 55),

                    // =====================================================
                    // SUCCESS ICON
                    // =====================================================
                    Container(
                      width: 110,
                      height: 110,

                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),

                      child: Container(
                        margin: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          Icons.check_rounded,
                          size: 58,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =====================================================
                    // TITLE
                    // =====================================================
                    Text(
                      "Order Placed!",
                      textAlign: TextAlign.center,

                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "Thank you for shopping with Handa Grocery.\nYour order has been placed successfully.",
                      textAlign: TextAlign.center,

                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.6,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          // ORDER ID
                          _infoRow(
                            icon: Icons.receipt_long_outlined,
                            title: "Order ID",
                            value: _shortOrderId(orderId),
                          ),

                          const SizedBox(height: 18),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 18),

                          // PAYMENT
                          _infoRow(
                            icon: Icons.payments_outlined,
                            title: "Payment Method",
                            value: "Cash on Delivery",
                          ),

                          const SizedBox(height: 18),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 18),

                          // STATUS
                          _infoRow(
                            icon: Icons.check_circle_outline,
                            title: "Order Status",
                            value: "Order Placed",
                            valueColor: Colors.green.shade700,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // =====================================================
                    // COD INFORMATION
                    // =====================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.shade100),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                            width: 38,
                            height: 38,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Icon(
                              Icons.local_atm_outlined,
                              size: 20,
                              color: Colors.amber.shade800,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Cash on Delivery",

                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  "Please keep the order amount ready when your order arrives.",

                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    height: 1.5,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),

              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailScreen(orderId: orderId),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(Icons.receipt_long_outlined, size: 20),

                            const SizedBox(width: 9),

                            Text(
                              "View Order",

                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,

                            MaterialPageRoute(
                              builder: (_) => const BottomNav(),
                            ),

                            (route) => false,
                          );
                        },

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,

                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20),

                            const SizedBox(width: 9),

                            Text(
                              "Continue Shopping",

                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // INFO ROW
  // ===============================================================

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, size: 21, color: Colors.grey.shade700),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // SHORT ORDER ID
  // ===============================================================

  String _shortOrderId(String id) {
    if (id.length <= 12) {
      return id;
    }

    return "${id.substring(0, 6)}...${id.substring(id.length - 6)}";
  }
}
