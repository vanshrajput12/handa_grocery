import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handa_grocery/models/CardItem_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _wishlistCollection {
    return _firestore.collection('users').doc(_userId).collection('wishlist');
  }

  // ADD TO WISHLIST

  Future<void> addToWishlist(CardItemModel product) async {
    await _wishlistCollection.doc(product.text).set({
      'text': product.text,
      'image': product.image,
      'price': product.price,
      'description': product.description,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
  // REMOVE FROM WISHLIST

  Future<void> removeFromWishlist(String productName) async {
    await _wishlistCollection.doc(productName).delete();
  }

  // CHECK IF PRODUCT IS WISHLISTED

  Future<bool> isWishlisted(String productName) async {
    final document = await _wishlistCollection.doc(productName).get();
    return document.exists;
  }

  // GET ALL WISHLIST PRODUCTS

  Stream<List<CardItemModel>> getWishlist() {
    return _wishlistCollection
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return CardItemModel(
              text: data['text'] ?? '',
              image: data['image'] ?? '',
              price: data['price'] ?? '',
              description: data['description'] ?? '',
            );
          }).toList();
        });
  }
}
