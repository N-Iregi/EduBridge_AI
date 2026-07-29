import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mentorship_session_entity.dart';

/// Adds Firestore (de)serialization on top of [MentorshipSessionEntity].
class MentorshipSessionModel extends MentorshipSessionEntity {
  const MentorshipSessionModel({
    required super.id,
    required super.studentId,
    required super.mentorId,
    required super.status,
    required super.scheduledAt,
    required super.topic,
    required super.notes,
    required super.meetingLink,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Builds a session from a Firestore document's field data, using
  /// [documentId] as the id. Missing fields fall back to empty values (or
  /// 'pending' for [status]) rather than throwing.
  factory MentorshipSessionModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return MentorshipSessionModel(
      id: documentId,
      studentId: map['studentId'] as String? ?? '',
      mentorId: map['mentorId'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      scheduledAt:
          (map['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      topic: map['topic'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      meetingLink: map['meetingLink'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory MentorshipSessionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return MentorshipSessionModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `mentorship_sessions` document.
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'mentorId': mentorId,
      'status': status,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'topic': topic,
      'notes': notes,
      'meetingLink': meetingLink,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns a copy with the given fields replaced — a status change, a
  /// rescheduled time, an added meeting link. [studentId] and [mentorId]
  /// are fixed once a session is booked, so they're not parameters here.
  MentorshipSessionModel copyWith({
    String? status,
    DateTime? scheduledAt,
    String? topic,
    String? notes,
    String? meetingLink,
    DateTime? updatedAt,
  }) {
    return MentorshipSessionModel(
      id: id,
      studentId: studentId,
      mentorId: mentorId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      topic: topic ?? this.topic,
      notes: notes ?? this.notes,
      meetingLink: meetingLink ?? this.meetingLink,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
