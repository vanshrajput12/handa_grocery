import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/cart_service.dart';

class OrderService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  OrderService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<String> placeOrder({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String paymentMethod,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    final CartService cartService = CartService();

    if (cartService.items.isEmpty) {
      throw Exception("Your cart is empty");
    }

    final orderReference = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc();

    final List<Map<String, dynamic>> items =
    cartService.items.map((item) {
      return {
        'productName': item.product.text,
        'price': item.unitPrice,
        'quantity': item.quantity,
        'totalPrice': item.totalPrice,
        'image': item.product.image,
      };
    }).toList();

    final Map<String, dynamic> orderData = {
      'orderId': orderReference.id,

      'userId': user.uid,

      'userEmail': user.email,

      'items': items,

      'totalItems': cartService.itemCount,

      'totalAmount': cartService.totalAmount,

      'deliveryAddress': {
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
      },

      'paymentMethod': paymentMethod,

      'paymentStatus': 'Pending',

      'orderStatus': 'Order Placed',

      'createdAt': FieldValue.serverTimestamp(),

      'updatedAt': FieldValue.serverTimestamp(),
    };

    await orderReference.set(orderData);

    return orderReference.id;
  }

  // ============================================================
  // GET USER ORDERS
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders() {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrder(
      String orderId,
      ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    return await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .get();
  }
}