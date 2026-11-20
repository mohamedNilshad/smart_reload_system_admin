import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class LoginUseCase {
  final AuthRepo repo;
  LoginUseCase(this.repo);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repo.login(email: email, password: password);
  }
}