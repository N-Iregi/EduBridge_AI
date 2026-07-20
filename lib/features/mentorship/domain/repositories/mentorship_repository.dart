import '../entities/mentorship_session_entity.dart';

/// Abstract definition of database operations regarding Mentorship Session entities.
abstract class MentorshipRepository {
  /// Retrieves sessions requested by a specific student.
  Future<List<MentorshipSessionEntity>> getSessionsByStudentId(
    String studentId,
  );

  /// Retrieves sessions hosted by a specific mentor.
  Future<List<MentorshipSessionEntity>> getSessionsByMentorId(String mentorId);

  /// Saves a newly requested mentorship session to the database.
  Future<void> bookSession(MentorshipSessionEntity session);

  /// Updates details of an existing session (e.g. status changes, zoom links).
  Future<void> updateSession(MentorshipSessionEntity session);

  /// Cancels/deletes a mentorship session booking.
  Future<void> cancelSession(String id);
}
