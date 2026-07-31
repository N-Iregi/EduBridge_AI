import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/deadline_entity.dart';
import '../../domain/repositories/deadline_repository.dart';
import '../models/deadline_model.dart';

/// Firestore implementation of [DeadlineRepository].
class FirestoreDeadlineRepository implements DeadlineRepository {
  final FirebaseFirestore _firestore;

  FirestoreDeadlineRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _deadlinesCollection =>
      _firestore.collection('deadlines');

  @override
  Future<List<DeadlineEntity>> getDeadlines(String userId) async {
    try {
      final snapshot = await _deadlinesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate')
          .get();
      return snapshot.docs
          .map((doc) => DeadlineModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createDeadline(DeadlineEntity deadline) async {
    try {
      final model = DeadlineModel(
        id: deadline.id,
        userId: deadline.userId,
        title: deadline.title,
        dueDate: deadline.dueDate,
        createdAt: deadline.createdAt,
      );
      final docRef = _deadlinesCollection.doc();
      await docRef.set(model.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDeadline(DeadlineEntity deadline) async {
    try {
      final model = DeadlineModel(
        id: deadline.id,
        userId: deadline.userId,
        title: deadline.title,
        dueDate: deadline.dueDate,
        createdAt: deadline.createdAt,
      );
      await _deadlinesCollection.doc(deadline.id).update(model.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDeadline(String id) async {
    try {
      await _deadlinesCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
