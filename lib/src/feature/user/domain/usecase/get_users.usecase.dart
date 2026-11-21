import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/repository/user.repo.dart';

class GetUsersUseCase {
  final UserRepo repo;
  GetUsersUseCase(this.repo);

  Future<Either<Failure, List<AdminUserEntity>>> call() => repo.getUsers();
}
