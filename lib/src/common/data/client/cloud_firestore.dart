import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore {
  const CloudFirestore();

  Future<void> create({
    required final String collection,
    required final Map<String, dynamic> data,
  }) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Error creating document: $e');
    }
  }

  Future<DocumentSnapshot> read({
    required final String collection,
    required final String documentId,
  }) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(collection).doc(documentId).get();
      return documentSnapshot;
    } catch (e) {
      throw Exception('Error reading document: $e');
    }
  }

  Future<void> update({
    required final String collection,
    required final String documentId,
    required final Map<String, dynamic> data,
  }) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Error updating document: $e');
    }
  }

  Future<void> delete({
    required final String collection,
    required final String documentId,
  }) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }
}
