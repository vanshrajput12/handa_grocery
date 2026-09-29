import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/order_service.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();
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

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MY ORDERS",
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              "Your Ordered grocery items",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),

      // ============================================================
      // ORDERS
      // ============================================================
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: orderService.getUserOrders(),

        builder: (context, snapshot) {
          // ==========================================================
          // LOADING
          // ==========================================================

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          // ==========================================================
          // ERROR
          // ==========================================================

          if (snapshot.hasError) {
            return _errorView(context, "Unable to load your orders.");
          }

          // ==========================================================
          // NO ORDERS
          // ==========================================================

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _emptyOrdersView(context);
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;

          // ==========================================================
          // ORDER LIST
          // ==========================================================

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 25),

            itemCount: orders.length,

            itemBuilder: (context, index) {
              final Map<String, dynamic> order = orders[index].data();

              return _orderCard(context: context, order: order);
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _orderCard({
    required BuildContext context,
    required Map<String, dynamic> order,
  }) {
    final String orderId = order['orderId']?.toString() ?? '';

    final String orderStatus =
        order['orderStatus']?.toString() ?? 'Order Placed';

    final String paymentStatus =
        order['paymentStatus']?.toString() ?? 'Pending';

    final String paymentMethod =
        order['paymentMethod']?.toString() ?? 'Cash on Delivery';

    final num totalAmount = order['totalAmount'] is num
        ? order['totalAmount'] as num
        : 0;

    final int totalItems = order['totalItems'] is num
        ? (order['totalItems'] as num).toInt()
        : 0;

    final List<dynamic> items = order['items'] is List
        ? order['items'] as List<dynamic>
        : [];

    final Timestamp? createdAt = order['createdAt'] is Timestamp
        ? order['createdAt'] as Timestamp
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ORDER HEADER
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(13),
                  ),

                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.amber.shade800,
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

            Divider(color: Colors.grey.shade200, height: 1),

            const SizedBox(height: 15),

            // ========================================================
            // PRODUCTS
            // ========================================================
            Text(
              "Products",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            ...items.map((item) {
              if (item is! Map) {
                return const SizedBox.shrink();
              }

              return _productItem(item: Map<String, dynamic>.from(item));
            }),

            const SizedBox(height: 5),

            Divider(color: Colors.grey.shade200, height: 1),

            const SizedBox(height: 14),

            // ========================================================
            // ORDER INFORMATION
            // ========================================================
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

            // ========================================================
            // TOTAL
            // ========================================================
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Total Amount",

                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "₹${totalAmount.toStringAsFixed(0)}",

                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ========================================================
            // ORDER ID
            // ========================================================
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

    final int quantity = item['quantity'] is num
        ? (item['quantity'] as num).toInt()
        : 0;

    final num totalPrice = item['totalPrice'] is num
        ? item['totalPrice'] as num
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          // ========================================================
          // PRODUCT IMAGE
          // ========================================================
          Container(
            width: 65,
            height: 65,

            padding: const EdgeInsets.all(7),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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

          // ========================================================
          // PRODUCT DETAILS
          // ========================================================
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

          // ========================================================
          // PRODUCT TOTAL
          // ========================================================
          Text(
            "₹${totalPrice.toStringAsFixed(0)}",

            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
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
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;

      case 'cancelled':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;

      case 'out for delivery':
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;

      case 'shipped':
        backgroundColor = Colors.purple.shade50;
        textColor = Colors.purple.shade700;
        break;

      default:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),

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
  // INFORMATION ROW
  // ============================================================

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.grey.shade600),

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
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY ORDERS
  // ============================================================

  Widget _emptyOrdersView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.shopping_bag_outlined,
                size: 42,
                color: Colors.amber.shade800,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "No Orders Yet",

              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
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

  // ============================================================
  // ERROR VIEW
  // ============================================================

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
              color: Colors.red.shade400,
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
                  MaterialPageRoute(builder: (_) => const OrderDetail()),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
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
  // SHORT ORDER ID
  // ============================================================

  String _shortOrderId(String orderId) {
    if (orderId.length <= 8) {
      return orderId;
    }

    return orderId.substring(0, 8).toUpperCase();
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

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

  // ============================================================
  // PAYMENT STATUS COLOR
  // ============================================================

  Color _paymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green.shade700;

      case 'failed':
        return Colors.red.shade700;

      default:
        return Colors.orange.shade700;
    }
  }
}
