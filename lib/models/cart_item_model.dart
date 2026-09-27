import 'package:handa_grocery/models/CardItem_model.dart';

class CartItemModel {
  final CardItemModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get unitPrice {
    return double.tryParse(
      product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
    ) ??
        0;
  }

  double get totalPrice => unitPrice * quantity;
}