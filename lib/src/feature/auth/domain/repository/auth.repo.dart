import 'package:dartz/dartz.dart';

import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});

  Future<Either<Failure, bool>> forgotPassword(String email);

  Future<Either<Failure, void>> reauthenticate(String password);

  Future<Either<Failure, void>> logout();

  Stream<UserEntity?> watchUser(String uid);

  Future<void> updateUser(String uid, Map<String, dynamic> data);

  Future<UserEntity?> getCachedUser();

  Future<void> updateCachedUser(UserEntity user);

  Future<void> clearCachedUser();
}