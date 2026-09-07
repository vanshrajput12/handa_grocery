import 'package:cloud_firestore/cloud_firestore.dart';

class CardItemModel {
  final String image;
  final String text;
  final String price;
  final String description;

  CardItemModel({
    required this.image,
    required this.text,
    required this.price,
    required this.description,
  });
  factory CardItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return CardItemModel(
      text: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: data['price'] as String? ?? "",
      image: data['image'] as String? ?? '',
    );
  }

  // convert medicine to dart format using map
  Map<String, dynamic> toMap() {
    return {
      'name': text,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
