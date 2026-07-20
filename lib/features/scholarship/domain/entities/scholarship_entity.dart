import 'package:equatable/equatable.dart';

/// Entity class representing a scholarship program.
class ScholarshipEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String amount;
  final DateTime deadline;
  final String eligibilityCriteria;
  final String provider;
  final String applicationUrl;
  final String category; // 'undergraduate' | 'postgraduate' | 'STEM' | etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScholarshipEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.eligibilityCriteria,
    required this.provider,
    required this.applicationUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    deadline,
    eligibilityCriteria,
    provider,
    applicationUrl,
    category,
    createdAt,
    updatedAt,
  ];
}
