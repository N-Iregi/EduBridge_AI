import 'package:equatable/equatable.dart';

/// A user's tracked deadline (e.g. a scholarship application due date).
class DeadlineEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final DateTime dueDate;
  final DateTime createdAt;

  const DeadlineEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.dueDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, title, dueDate, createdAt];
}
