import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore {
  const CloudFirestore({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<void> create({
    required final String collection,
    required final Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).add(data);
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<DocumentSnapshot> read({
    required final String collection,
    required final String documentId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> update({
    required final String collection,
    required final String documentId,
    required final Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> delete({
    required final String collection,
    required final String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
