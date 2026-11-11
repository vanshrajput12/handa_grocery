import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CardItem_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Streams all items of ONE category.
  /// The category name is the same as the Firestore collection name.
  Stream<List<CardItemModel>> streamCategory(String category) {
    return _db.collection(category).snapshots().map((snapshot) {
      // Sort in Dart (newest first), so docs without a 'name' field are not hidden
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