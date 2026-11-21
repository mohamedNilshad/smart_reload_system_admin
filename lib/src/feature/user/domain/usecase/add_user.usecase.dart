import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/repository/user.repo.dart';

class AddUserUseCase {
  final UserRepo repo;
  AddUserUseCase(this.repo);

  Future<Either<Failure, bool>> call(AdminUserEntity user) =>
      repo.addUser(user);
}
