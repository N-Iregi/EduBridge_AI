import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mentorship_session_entity.dart';
import '../../domain/repositories/mentorship_repository.dart';
import '../models/mentorship_session_model.dart';

/// Firestore implementation of the MentorshipRepository.
class FirestoreMentorshipRepository implements MentorshipRepository {
  final FirebaseFirestore _firestore;

  FirestoreMentorshipRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      _firestore.collection('mentorship_sessions');

  /// Sessions requested by [studentId], most recently scheduled first.
  @override
  Future<List<MentorshipSessionEntity>> getSessionsByStudentId(
    String studentId,
  ) async {
    try {
      final snapshot = await _sessionsCollection
          .where('studentId', isEqualTo: studentId)
          .orderBy('scheduledAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => MentorshipSessionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Sessions hosted by [mentorId], most recently scheduled first.
  @override
  Future<List<MentorshipSessionEntity>> getSessionsByMentorId(
    String mentorId,
  ) async {
    try {
      final snapshot = await _sessionsCollection
          .where('mentorId', isEqualTo: mentorId)
          .orderBy('scheduledAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => MentorshipSessionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new session, auto-generating an id when [session.id] is
  /// empty; overwrites the existing document otherwise.
  @override
  Future<void> bookSession(MentorshipSessionEntity session) async {
    try {
      final sessionModel = MentorshipSessionModel(
        id: session.id,
        studentId: session.studentId,
        mentorId: session.mentorId,
        status: session.status,
        scheduledAt: session.scheduledAt,
        topic: session.topic,
        notes: session.notes,
        meetingLink: session.meetingLink,
        createdAt: session.createdAt,
        updatedAt: session.updatedAt,
      );

      if (session.id.isEmpty) {
        final docRef = _sessionsCollection.doc();
        await docRef.set({...sessionModel.toMap(), 'id': docRef.id});
      } else {
        await _sessionsCollection.doc(session.id).set(sessionModel.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSession(MentorshipSessionEntity session) async {
    try {
      final sessionModel = MentorshipSessionModel(
        id: session.id,
        studentId: session.studentId,
        mentorId: session.mentorId,
        status: session.status,
        scheduledAt: session.scheduledAt,
        topic: session.topic,
        notes: session.notes,
        meetingLink: session.meetingLink,
        createdAt: session.createdAt,
        updatedAt: session.updatedAt,
      );
      await _sessionsCollection.doc(session.id).update(sessionModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the session outright. Note this bypasses the 'cancelled'
  /// value [MentorshipSessionEntity.status] defines — callers that want to
  /// keep a record of the cancellation should call [updateSession] with
  /// status 'cancelled' instead of this method.
  @override
  Future<void> cancelSession(String id) async {
    try {
      await _sessionsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
