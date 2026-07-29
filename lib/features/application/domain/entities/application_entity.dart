import 'package:equatable/equatable.dart';

/// A scholarship application submitted by a student.
class ApplicationEntity extends Equatable {
  final String id;
  final String userId;
  final String scholarshipId;
  final String
  scholarshipTitle; // denormalized for displaying on lists without joins
  final String status; // 'applied' | 'in_progress' | 'accepted' | 'rejected'
  final DateTime appliedAt;
  final List<String> documents; // file URLs of resumes, essays etc
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ApplicationEntity({
    required this.id,
    required this.userId,
    required this.scholarshipId,
    required this.scholarshipTitle,
    required this.status,
    required this.appliedAt,
    required this.documents,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    scholarshipId,
    scholarshipTitle,
    status,
    appliedAt,
    documents,
    notes,
    createdAt,
    updatedAt,
  ];
}
