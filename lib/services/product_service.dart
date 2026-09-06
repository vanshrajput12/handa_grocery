import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CardItem_model.dart';

class ProductService {

  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('Rice');

  Stream<List<CardItemModel>> StreamRice() {
    return _collection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => CardItemModel.fromFirestore(doc)).toList(),
    );
  }
}