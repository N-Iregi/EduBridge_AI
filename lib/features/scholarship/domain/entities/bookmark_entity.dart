import 'package:equatable/equatable.dart';

/// Records that a user bookmarked a specific scholarship.
class BookmarkEntity extends Equatable {
  final String id; // structured as: userId_scholarshipId
  final String userId;
  final String scholarshipId;
  final DateTime bookmarkedAt;

  const BookmarkEntity({
    required this.id,
    required this.userId,
    required this.scholarshipId,
    required this.bookmarkedAt,
  });

  @override
  List<Object?> get props => [id, userId, scholarshipId, bookmarkedAt];
}
