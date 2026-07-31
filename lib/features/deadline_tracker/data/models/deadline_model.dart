import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/deadline_entity.dart';

/// Adds Firestore (de)serialization on top of [DeadlineEntity].
class DeadlineModel extends DeadlineEntity {
  const DeadlineModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.dueDate,
    required super.createdAt,
  });

  /// Builds a deadline from a Firestore document's field data, using
  /// [documentId] as the id. Falls back to empty/now values on missing
  /// fields rather than throwing.
  factory DeadlineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DeadlineModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory DeadlineModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return DeadlineModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `deadlines` document.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
