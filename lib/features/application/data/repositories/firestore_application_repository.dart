import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../models/application_model.dart';

/// Firestore implementation of the ApplicationRepository.
class FirestoreApplicationRepository implements ApplicationRepository {
  final FirebaseFirestore _firestore;

  FirestoreApplicationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _applicationsCollection =>
      _firestore.collection('applications');

  /// Applications submitted by [userId], most recently applied-to first.
  @override
  Future<List<ApplicationEntity>> getApplicationsByUserId(String userId) async {
    try {
      final snapshot = await _applicationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('appliedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ApplicationModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApplicationEntity?> getApplicationById(String id) async {
    try {
      final doc = await _applicationsCollection.doc(id).get();
      if (doc.exists) {
        return ApplicationModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new application document, auto-generating an id when
  /// [application.id] is empty; overwrites the existing document otherwise.
  @override
  Future<void> submitApplication(ApplicationEntity application) async {
    try {
      final applicationModel = ApplicationModel(
        id: application.id,
        userId: application.userId,
        scholarshipId: application.scholarshipId,
        scholarshipTitle: application.scholarshipTitle,
        status: application.status,
        appliedAt: application.appliedAt,
        documents: application.documents,
        notes: application.notes,
        createdAt: application.createdAt,
        updatedAt: application.updatedAt,
      );

      if (application.id.isEmpty) {
        final docRef = _applicationsCollection.doc();
        await docRef.set({...applicationModel.toMap(), 'id': docRef.id});
      } else {
        await _applicationsCollection
            .doc(application.id)
            .set(applicationModel.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateApplication(ApplicationEntity application) async {
    try {
      final applicationModel = ApplicationModel(
        id: application.id,
        userId: application.userId,
        scholarshipId: application.scholarshipId,
        scholarshipTitle: application.scholarshipTitle,
        status: application.status,
        appliedAt: application.appliedAt,
        documents: application.documents,
        notes: application.notes,
        createdAt: application.createdAt,
        updatedAt: application.updatedAt,
      );
      await _applicationsCollection
          .doc(application.id)
          .update(applicationModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the application outright — [ApplicationEntity.status] has no
  /// 'cancelled' value, so removing the record is how cancellation is
  /// represented.
  @override
  Future<void> cancelApplication(String id) async {
    try {
      await _applicationsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
