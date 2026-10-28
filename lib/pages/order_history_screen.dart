import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/order_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amberSoft = Color(0xFFFFF4D6);
  static const amberText = Color(0xFF9A6B00);

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: orderService.getUserOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: green),
                  );
                }

                if (snapshot.hasError) {
                  return _errorView(context, "Unable to load your orders.");
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _emptyOrdersView();
                }

                final orders = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 25),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _orderCard(order: orders[index].data());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GREEN CURVED HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
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
                      "My Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Your ordered grocery items",
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
                  Icons.receipt_long_outlined,
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

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _orderCard({required Map<String, dynamic> order}) {
    final String orderId = order['orderId']?.toString() ?? '';
    final String orderStatus =
        order['orderStatus']?.toString() ?? 'Order Placed';
    final String paymentStatus =
        order['paymentStatus']?.toString() ?? 'Pending';
    final String paymentMethod =
        order['paymentMethod']?.toString() ?? 'Cash on Delivery';

    final num totalAmount =
    order['totalAmount'] is num ? order['totalAmount'] as num : 0;

    final int totalItems = order['totalItems'] is num
        ? (order['totalItems'] as num).toInt()
        : 0;

    final List<dynamic> items =
    order['items'] is List ? order['items'] as List<dynamic> : [];

    final Timestamp? createdAt =
    order['createdAt'] is Timestamp ? order['createdAt'] as Timestamp : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDF3EE)),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: green,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${_shortOrderId(orderId)}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        createdAt == null
                            ? "Date unavailable"
                            : _formatDate(createdAt.toDate()),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(orderStatus),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEDF1ED), height: 1),
            const SizedBox(height: 15),

            Text(
              "Products",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 12),

            ...items.map((item) {
              if (item is! Map) return const SizedBox.shrink();
              return _productItem(item: Map<String, dynamic>.from(item));
            }),

            const SizedBox(height: 5),
            const Divider(color: Color(0xFFEDF1ED), height: 1),
            const SizedBox(height: 14),

            _infoRow(
              icon: Icons.shopping_cart_outlined,
              title: "Total Items",
              value: "$totalItems",
            ),
            const SizedBox(height: 9),
            _infoRow(
              icon: Icons.payment_outlined,
              title: "Payment",
              value: paymentMethod,
            ),
            const SizedBox(height: 9),
            _infoRow(
              icon: Icons.verified_outlined,
              title: "Payment Status",
              value: paymentStatus,
              valueColor: _paymentStatusColor(paymentStatus),
            ),

            const SizedBox(height: 15),

            // TOTAL
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD7EBDD)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                  Text(
                    "₹${totalAmount.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 15,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Order ID: $orderId",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT ITEM
  // ============================================================

  Widget _productItem({required Map<String, dynamic> item}) {
    final String productName = item['productName']?.toString() ?? 'Product';
    final String image = item['image']?.toString() ?? '';
    final num price = item['price'] is num ? item['price'] as num : 0;
    final int quantity =
    item['quantity'] is num ? (item['quantity'] as num).toInt() : 0;
    final num totalPrice =
    item['totalPrice'] is num ? item['totalPrice'] as num : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: image.isEmpty
                ? Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.shade400,
            )
                : Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey.shade400,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "₹${price.toStringAsFixed(0)} × $quantity",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "₹${totalPrice.toStringAsFixed(0)}",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: green,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        backgroundColor = lightGreen;
        textColor = green;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'out for delivery':
        backgroundColor = const Color(0xFFE3F4EE);
        textColor = deepGreen;
        break;
      case 'shipped':
        backgroundColor = const Color(0xFFE3F4EE);
        textColor = deepGreen;
        break;
      default:
        backgroundColor = amberSoft;
        textColor = amberText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17, color: green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: valueColor ?? darkText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY / ERROR
  // ============================================================

  Widget _emptyOrdersView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 42,
                color: green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Orders Yet",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your previous orders will appear here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Try Again",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _shortOrderId(String orderId) {
    if (orderId.length <= 8) return orderId;
    return orderId.substring(0, 8).toUpperCase();
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();

    final int hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';

    return "$day/$month/$year • $hour:$minute $period";
  }

  Color _paymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return green;
      case 'failed':
        return Colors.red.shade700;
      default:
        return amberText;
    }
  }
}