import 'package:flutter/foundation.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/models/cart_item_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount {
    return _items.fold(
      0,
          (total, item) => total + item.quantity,
    );
  }

  double get totalAmount {
    return _items.fold(
      0,
          (total, item) => total + item.totalPrice,
    );
  }

  void addToCart(
      CardItemModel product, {
        int quantity = 1,
      }) {
    final index = _items.indexWhere(
          (item) => item.product.text == product.text,
    );

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(String productName) {
    final index = _items.indexWhere(
          (item) => item.product.text == productName,
    );

    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productName) {
    final index = _items.indexWhere(
          (item) => item.product.text == productName,
    );

    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }

      notifyListeners();
    }
  }

  void removeFromCart(String productName) {
    _items.removeWhere(
          (item) => item.product.text == productName,
    );

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}