import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mentorship_session_entity.dart';

/// Data model representing a mentorship session.
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

  /// Factory constructor to create a MentorshipSessionModel from Map data.
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

  /// Factory constructor to deserialize a Firestore DocumentSnapshot.
  factory MentorshipSessionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return MentorshipSessionModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Converts the model into a Map format suitable for Firestore.
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

  /// Utility to copy the model with modifications.
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
