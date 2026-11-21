import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/entity/notification.entity.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/repository/notification.repo.dart';

class GetNotificationsUseCase {
  final NotificationRepo repo;
  GetNotificationsUseCase(this.repo);

  Future<Either<Failure, List<NotificationEntity>>> call(String uid) => repo.getNotifications(uid);
}