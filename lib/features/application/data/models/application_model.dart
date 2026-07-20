import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';

/// Data model representing a scholarship application.
class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.userId,
    required super.scholarshipId,
    required super.scholarshipTitle,
    required super.status,
    required super.appliedAt,
    required super.documents,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor to create an ApplicationModel from Map data.
  factory ApplicationModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return ApplicationModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      scholarshipId: map['scholarshipId'] as String? ?? '',
      scholarshipTitle: map['scholarshipTitle'] as String? ?? '',
      status: map['status'] as String? ?? 'applied',
      appliedAt: (map['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      documents: List<String>.from(map['documents'] as List? ?? []),
      notes: map['notes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Factory constructor to deserialize a Firestore DocumentSnapshot.
  factory ApplicationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return ApplicationModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Converts the model into a Map format suitable for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'scholarshipId': scholarshipId,
      'scholarshipTitle': scholarshipTitle,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'documents': documents,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Utility to copy the model with modifications.
  ApplicationModel copyWith({
    String? status,
    List<String>? documents,
    String? notes,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      id: id,
      userId: userId,
      scholarshipId: scholarshipId,
      scholarshipTitle: scholarshipTitle,
      status: status ?? this.status,
      appliedAt: appliedAt,
      documents: documents ?? this.documents,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
