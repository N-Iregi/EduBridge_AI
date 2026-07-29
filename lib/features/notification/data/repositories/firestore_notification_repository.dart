import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

/// Firestore implementation of the NotificationRepository.
class FirestoreNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  /// Notifications targeted at [userId], newest first.
  @override
  Future<List<NotificationEntity>> getNotificationsByUserId(
    String userId,
  ) async {
    try {
      final snapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => NotificationModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new notification, auto-generating an id when
  /// [notification.id] is empty; overwrites the existing document otherwise.
  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    try {
      final notificationModel = NotificationModel(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        body: notification.body,
        isRead: notification.isRead,
        createdAt: notification.createdAt,
      );

      if (notification.id.isEmpty) {
        final docRef = _notificationsCollection.doc();
        await docRef.set({...notificationModel.toMap(), 'id': docRef.id});
      } else {
        await _notificationsCollection
            .doc(notification.id)
            .set(notificationModel.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Flips `isRead` to true with a single-field update, rather than
  /// round-tripping the whole notification through the model.
  @override
  Future<void> markAsRead(String id) async {
    try {
      await _notificationsCollection.doc(id).update({'isRead': true});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _notificationsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
