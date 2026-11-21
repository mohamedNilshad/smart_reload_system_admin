import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';

abstract class UserRepo {
  Future<Either<Failure, List<AdminUserEntity>>> getUsers();
  Future<Either<Failure, bool>> addUser(AdminUserEntity user);
  Future<Either<Failure, bool>> updateUser(AdminUserEntity user);
  Future<Either<Failure, bool>> deleteUser(String userId);
}
