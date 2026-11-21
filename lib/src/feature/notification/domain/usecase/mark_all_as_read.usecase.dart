import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/repository/notification.repo.dart';
class MarkAllAsReadUseCase {
  final NotificationRepo repo;
  MarkAllAsReadUseCase(this.repo);

  Future<Either<Failure, void>> call(String uid) => repo.markAllAsRead(uid);
}