import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/repository/user.repo.dart';

class DeleteUserUseCase {
  final UserRepo repo;
  DeleteUserUseCase(this.repo);

  Future<Either<Failure, bool>> call(String userId) => repo.deleteUser(userId);
}
