import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';

class ReauthenticateUseCase {
  final AuthRepo repo;
  ReauthenticateUseCase(this.repo);

  Future<Either<Failure, void>> call(String password) => repo.reauthenticate(password);
}