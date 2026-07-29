import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';

/// Adds Firestore (de)serialization on top of [ApplicationEntity].
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

  /// Builds an application from a Firestore document's field data. The
  /// document id isn't part of the map itself, so it's passed separately
  /// as [documentId]. A missing or malformed field falls back to an empty
  /// value (or 'applied' for [status]) rather than throwing, so a
  /// partially-written document still deserializes.
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

  /// Same as [fromMap], but reads straight from a query/document snapshot.
  factory ApplicationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return ApplicationModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for a Firestore `set`/`update` call. The id itself is never
  /// included — Firestore already knows it from the document path.
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

  /// Returns a copy with the given fields replaced. Deliberately scoped to
  /// what actually changes after submission — status updates, new
  /// documents, or notes — rather than every field on the model.
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
