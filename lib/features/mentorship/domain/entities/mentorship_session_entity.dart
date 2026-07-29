import 'package:equatable/equatable.dart';

/// A booked or requested mentorship session between a student and a mentor.
class MentorshipSessionEntity extends Equatable {
  final String id;
  final String studentId;
  final String mentorId;
  final String status; // 'pending' | 'scheduled' | 'completed' | 'cancelled'
  final DateTime scheduledAt;
  final String topic;
  final String notes;
  final String meetingLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MentorshipSessionEntity({
    required this.id,
    required this.studentId,
    required this.mentorId,
    required this.status,
    required this.scheduledAt,
    required this.topic,
    required this.notes,
    required this.meetingLink,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    mentorId,
    status,
    scheduledAt,
    topic,
    notes,
    meetingLink,
    createdAt,
    updatedAt,
  ];
}
