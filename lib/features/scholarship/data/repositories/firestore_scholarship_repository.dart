import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../../domain/repositories/scholarship_repository.dart';
import '../models/scholarship_model.dart';

/// Firestore implementation of the ScholarshipRepository.
class FirestoreScholarshipRepository implements ScholarshipRepository {
  final FirebaseFirestore _firestore;

  FirestoreScholarshipRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _scholarshipsCollection =>
      _firestore.collection('scholarships');

  /// Every scholarship listing, newest first.
  @override
  Future<List<ScholarshipEntity>> getScholarships() async {
    try {
      final snapshot = await _scholarshipsCollection
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ScholarshipModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScholarshipEntity?> getScholarshipById(String id) async {
    try {
      final doc = await _scholarshipsCollection.doc(id).get();
      if (doc.exists) {
        return ScholarshipModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Scholarships in [category], newest first. Filtering on one field and
  /// ordering on another is exactly the shape of query Firestore requires
  /// a composite index for once a collection is large enough to need one —
  /// if this starts throwing a "failed-precondition" error in production,
  /// that's the fix.
  @override
  Future<List<ScholarshipEntity>> getScholarshipsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _scholarshipsCollection
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ScholarshipModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new listing, auto-generating an id when [scholarship.id] is
  /// empty; overwrites the existing document otherwise. Intended for admin
  /// use, per [ScholarshipRepository].
  @override
  Future<void> createScholarship(ScholarshipEntity scholarship) async {
    try {
      final scholarshipModel = ScholarshipModel(
        id: scholarship.id,
        title: scholarship.title,
        description: scholarship.description,
        amount: scholarship.amount,
        deadline: scholarship.deadline,
        eligibilityCriteria: scholarship.eligibilityCriteria,
        provider: scholarship.provider,
        applicationUrl: scholarship.applicationUrl,
        category: scholarship.category,
        createdAt: scholarship.createdAt,
        updatedAt: scholarship.updatedAt,
      );
      // Empty id means this is a new scholarship — let Firestore generate one.
      if (scholarship.id.isEmpty) {
        final docRef = _scholarshipsCollection.doc();
        await docRef.set({...scholarshipModel.toMap(), 'id': docRef.id});
      } else {
        await _scholarshipsCollection
            .doc(scholarship.id)
            .set(scholarshipModel.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateScholarship(ScholarshipEntity scholarship) async {
    try {
      final scholarshipModel = ScholarshipModel(
        id: scholarship.id,
        title: scholarship.title,
        description: scholarship.description,
        amount: scholarship.amount,
        deadline: scholarship.deadline,
        eligibilityCriteria: scholarship.eligibilityCriteria,
        provider: scholarship.provider,
        applicationUrl: scholarship.applicationUrl,
        category: scholarship.category,
        createdAt: scholarship.createdAt,
        updatedAt: scholarship.updatedAt,
      );
      await _scholarshipsCollection
          .doc(scholarship.id)
          .update(scholarshipModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteScholarship(String id) async {
    try {
      await _scholarshipsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
