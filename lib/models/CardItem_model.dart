import 'package:cloud_firestore/cloud_firestore.dart';

class CardItemModel {
  final String text;
  final String image;
  final String price;
  final String description;

  /// The full Firestore document, for any extra fields.
  final Map<String, dynamic> data;

  CardItemModel({
    required this.text,
    required this.image,
    required this.price,
    this.description = '',
    this.data = const {},
  });

  /// Works for both number prices (20) and text prices ("150/kg").
  /// Adds the ₹ sign when it is missing.
  static String _price(dynamic v) {
    final s = (v ?? '').toString().trim();
    if (s.isEmpty) return '';
    return s.startsWith('₹') ? s : '₹$s';
  }

  factory CardItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return CardItemModel(
      text: (map['text'] ?? '').toString().trim(),
      image: (map['image'] ?? '').toString().trim(),
      price: _price(map['price']),
      description: (map['description'] ?? '').toString().trim(),
      data: map,
    );
  }
}