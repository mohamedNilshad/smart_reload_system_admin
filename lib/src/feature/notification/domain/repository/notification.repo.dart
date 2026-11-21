import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/entity/notification.entity.dart';

abstract class NotificationRepo {
  /// Live unread count — the only thing that stays subscribed continuously.
  Stream<int> watchUnreadCount(String uid);

  /// One-shot fetch — called only when the user opens the notification screen.
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(String uid);

  Future<Either<Failure, void>> markAsRead({required String uid, required String notificationId});
  Future<Either<Failure, void>> markAllAsRead(String uid);
}