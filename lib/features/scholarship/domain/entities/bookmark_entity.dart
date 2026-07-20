import 'package:equatable/equatable.dart';

/// Entity class representing a bookmarked scholarship.
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
