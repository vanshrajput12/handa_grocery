import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/bottom%20Nav/Bottom_Nav.dart';
import 'order_detail_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amber = Color(0xFFFFB300);
  static const amberSoft = Color(0xFFFFF4D6);
  static const amberText = Color(0xFF9A6B00);

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final double heroHeight = 340 + topInset;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // =====================================================
                  // GREEN CELEBRATION HERO
                  // =====================================================
                  _buildHero(heroHeight, topInset),

                  // =====================================================
                  // CONTENT OVERLAPPING THE HERO
                  // =====================================================
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, heroHeight - 46, 20, 24),
                    child: Column(
                      children: [
                        _buildInfoCard(context),

                        const SizedBox(height: 18),

                        _buildProgressCard(),

                        const SizedBox(height: 18),

                        _buildCodNote(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // BOTTOM BUTTONS
          // =====================================================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailScreen(orderId: orderId),
                          ),
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
                          MaterialPageRoute(builder: (_) => const BottomNav()),
                              (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: green,
                        side: const BorderSide(
                          color: Color(0xFFBFE0C9),
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront_outlined, size: 20),
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
    );
  }

  // ===============================================================
  // HERO
  // ===============================================================

  Widget _buildHero(double height, double topInset) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [deepGreen, green],
          ),
        ),
        child: Stack(
          children: [
            // soft background circles
            Positioned(top: -50, right: -40, child: _circle(170, 0.07)),
            Positioned(bottom: -60, left: -50, child: _circle(150, 0.07)),

            // little celebration dots
            Positioned(
              top: topInset + 46,
              left: 38,
              child: _dot(10, amber),
            ),
            Positioned(
              top: topInset + 86,
              right: 46,
              child: _dot(8, Colors.white.withValues(alpha: 0.7)),
            ),
            Positioned(
              top: topInset + 150,
              left: 62,
              child: _dot(7, Colors.white.withValues(alpha: 0.55)),
            ),
            Positioned(
              top: topInset + 128,
              right: 30,
              child: _dot(12, amber.withValues(alpha: 0.9)),
            ),

            // content
            Padding(
              padding: EdgeInsets.only(top: topInset + 30, bottom: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // layered check icon
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 54,
                            color: green,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "Order Placed!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Thank you for shopping with Handa Grocery.\nYour order has been placed successfully.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.6,
                          color: Colors.white70,
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

  Widget _circle(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }

  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ===============================================================
  // INFO CARD
  // ===============================================================

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: deepGreen.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.receipt_long_outlined,
            title: "Order ID",
            value: _shortOrderId(orderId),
            trailing: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: orderId));

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Order ID copied",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    backgroundColor: green,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(15),
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.copy_rounded, size: 18, color: green),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFEDF1ED)),
          ),

          _infoRow(
            icon: Icons.payments_outlined,
            title: "Payment Method",
            value: "Cash on Delivery",
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFEDF1ED)),
          ),

          _infoRow(
            icon: Icons.check_circle_outline,
            title: "Order Status",
            value: "Order Placed",
            valueColor: green,
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // WHAT HAPPENS NEXT (progress)
  // ===============================================================

  Widget _buildProgressCard() {
    const steps = [
      "Placed",
      "Shipped",
      "On the way",
      "Delivered",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What happens next",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              // connector lines between the dots
              if (i.isOdd) {
                return Expanded(
                  child: Container(
                    height: 2,
                    color: const Color(0xFFDDE9DE),
                  ),
                );
              }

              final bool done = i == 0;

              return Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? green : Colors.white,
                  border: Border.all(
                    color: done ? green : const Color(0xFFCFE0D3),
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              );
            }),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (i) {
              return Text(
                steps[i],
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w500,
                  color: i == 0 ? green : Colors.grey.shade500,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // COD NOTE
  // ===============================================================

  Widget _buildCodNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: amberSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_atm_outlined,
              size: 21,
              color: amberText,
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
                    color: const Color(0xFF5E4B14),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Please keep the order amount ready when your order arrives.",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    height: 1.5,
                    color: const Color(0xFF6B5A2A),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, size: 22, color: green),
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
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? darkText,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
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