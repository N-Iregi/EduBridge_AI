import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/scholarship_entity.dart';

/// Adds Firestore (de)serialization on top of [ScholarshipEntity].
class ScholarshipModel extends ScholarshipEntity {
  const ScholarshipModel({
    required super.id,
    required super.title,
    required super.description,
    required super.amount,
    required super.deadline,
    required super.eligibilityCriteria,
    required super.provider,
    required super.applicationUrl,
    required super.category,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Builds a scholarship from a Firestore document's field data, using
  /// [documentId] as the id. Falls back to empty values (or 'general' for
  /// [category]) on missing fields rather than throwing.
  factory ScholarshipModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return ScholarshipModel(
      id: documentId,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      amount: map['amount'] as String? ?? '',
      deadline: (map['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eligibilityCriteria: map['eligibilityCriteria'] as String? ?? '',
      provider: map['provider'] as String? ?? '',
      applicationUrl: map['applicationUrl'] as String? ?? '',
      category: map['category'] as String? ?? 'general',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory ScholarshipModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return ScholarshipModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `scholarships` document.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': Timestamp.fromDate(deadline),
      'eligibilityCriteria': eligibilityCriteria,
      'provider': provider,
      'applicationUrl': applicationUrl,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns a copy with the given fields replaced — used when an admin
  /// edits a listing. [id] and [createdAt] stay fixed.
  ScholarshipModel copyWith({
    String? title,
    String? description,
    String? amount,
    DateTime? deadline,
    String? eligibilityCriteria,
    String? provider,
    String? applicationUrl,
    String? category,
    DateTime? updatedAt,
  }) {
    return ScholarshipModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      provider: provider ?? this.provider,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
