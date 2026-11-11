import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CardItem_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Category names created in the admin panel (oldest first).
  Stream<List<String>> streamCategories() {
    return _db.collection('categories').snapshots().map((snapshot) {
      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = a.data()['createdAt'] as Timestamp?;
          final bTime = b.data()['createdAt'] as Timestamp?;
          return (aTime?.millisecondsSinceEpoch ?? 0)
              .compareTo(bTime?.millisecondsSinceEpoch ?? 0);
        });

      return docs
          .map((d) => (d.data()['name'] ?? d.id).toString().trim())
          .where((name) => name.isNotEmpty)
          .toList();
    });
  }

  /// All items of ONE category (collection name = category name).
  Stream<List<CardItemModel>> streamCategory(String category) {
    return _db.collection(category).snapshots().map((snapshot) {
      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = a.data()['createdAt'] as Timestamp?;
          final bTime = b.data()['createdAt'] as Timestamp?;
          return (bTime?.millisecondsSinceEpoch ?? 0)
              .compareTo(aTime?.millisecondsSinceEpoch ?? 0);
        });

      return docs.map((doc) => CardItemModel.fromFirestore(doc)).toList();
    });
  }
}