import 'package:equatable/equatable.dart';

/// Entity class representing a system or deadline notification.
class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, title, body, isRead, createdAt];
}
