import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/notification/data/datasource/notification.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/entity/notification.entity.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/repository/notification.repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepoImpl(this.remoteDataSource);

  @override
  Stream<int> watchUnreadCount(String uid) => remoteDataSource.watchUnreadCount(uid);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(String uid) async {
    try {
      return Right(await remoteDataSource.getNotifications(uid));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message)); // swap for a NotificationFailure if you add one
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({required String uid, required String notificationId}) async {
    try {
      await remoteDataSource.markAsRead(uid: uid, notificationId: notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String uid) async {
    try {
      await remoteDataSource.markAllAsRead(uid);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}