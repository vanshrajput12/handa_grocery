import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CardItem_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Category names created in the admin panel (oldest first).
  /// The document ID is the collection name.
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
          .map((d) => d.id.trim())
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

  /// Items of EVERY category combined, updating live.
  /// New or deleted categories are picked up automatically.
  Stream<List<CardItemModel>> streamAllProducts() {
    late final StreamController<List<CardItemModel>> controller;
    StreamSubscription<List<String>>? categorySub;
    final Map<String, StreamSubscription<List<CardItemModel>>> productSubs = {};
    final Map<String, List<CardItemModel>> itemsByCategory = {};

    void emit() {
      if (controller.isClosed) return;
      controller.add(itemsByCategory.values.expand((list) => list).toList());
    }

    controller = StreamController<List<CardItemModel>>(
      onListen: () {
        categorySub = streamCategories().listen((categories) {
          // Stop listening to deleted categories
          final removed =
          productSubs.keys.where((c) => !categories.contains(c)).toList();
          for (final c in removed) {
            productSubs.remove(c)?.cancel();
            itemsByCategory.remove(c);
          }

          // Start listening to new categories
          for (final c in categories) {
            if (productSubs.containsKey(c)) continue;
            productSubs[c] = streamCategory(c).listen(
                  (items) {
                itemsByCategory[c] = items;
                emit();
              },
              onError: controller.addError,
            );
          }

          emit();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await categorySub?.cancel();
        for (final sub in productSubs.values) {
          await sub.cancel();
        }
        productSubs.clear();
      },
    );

    return controller.stream;
  }
}