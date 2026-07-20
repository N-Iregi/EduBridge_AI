import '../entities/notification_entity.dart';

/// Abstract definition of database operations regarding Notification entities.
abstract class NotificationRepository {
  /// Retrieves notifications targeted to a specific user.
  Future<List<NotificationEntity>> getNotificationsByUserId(String userId);

  /// Saves a notification (can be triggered by scheduler/auth flow).
  Future<void> sendNotification(NotificationEntity notification);

  /// Marks a specific notification as read.
  Future<void> markAsRead(String id);

  /// Deletes a specific notification.
  Future<void> deleteNotification(String id);
}
