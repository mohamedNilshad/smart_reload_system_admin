import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class LogoutUseCase {
  final AuthRepo repo;
  LogoutUseCase(this.repo);

  Future<Either<Failure, void>> call() => repo.logout();
}