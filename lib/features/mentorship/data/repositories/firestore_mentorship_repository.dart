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

  @override
  Future<void> cancelSession(String id) async {
    try {
      await _sessionsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
