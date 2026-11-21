import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/entity/notification.entity.dart';

abstract class NotificationRemoteDataSource {
  Stream<int> watchUnreadCount(String uid);
  Future<List<NotificationEntity>> getNotifications(String uid);
  Future<void> markAsRead({required String uid, required String notificationId});
  Future<void> markAllAsRead(String uid);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  NotificationRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      firestore.collection('users').doc(uid).collection('notifications');

  @override
  Stream<int> watchUnreadCount(String uid) {
    try{
      return _collection(uid)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.size);

    }catch(e, st){
      errorLog(
        e,
        location: 'NotificationRemoteDataSourceImpl.watchUnreadCount',
        stackTrace: st,
      );
      throw ServerException('Failed to watch unread notifications count.');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications(String uid) async {
    try {
      final snapshot = await _collection(uid).orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => NotificationEntity.fromFirestore(doc)).toList();
    } catch (e, st) {
      errorLog(
        e,
        location: 'NotificationRemoteDataSourceImpl.getNotifications',
        stackTrace: st,
      );
      throw ServerException('Failed to load notifications.');
    }
  }

  @override
  Future<void> markAsRead({required String uid, required String notificationId}) async {
    try {
      await _collection(uid).doc(notificationId).update({'isRead': true});
    } catch (e, st) {
      errorLog(
        e,
        location: 'NotificationRemoteDataSourceImpl.markAsRead',
        stackTrace: st,
      );
      throw ServerException('Failed to update notification.');
    }
  }

  @override
  Future<void> markAllAsRead(String uid) async {
    try {
      final unread = await _collection(uid).where('isRead', isEqualTo: false).get();
      final batch = firestore.batch();
      for (final doc in unread.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e, st) {
      errorLog(
        e,
        location: 'NotificationRemoteDataSourceImpl.markAllAsRead',
        stackTrace: st,
      );
      throw ServerException('Failed to update notifications.');
    }
  }
}