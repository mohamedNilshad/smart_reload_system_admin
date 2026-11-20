import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';

class VerifyEmailUseCase {
  final AuthRepo repo;
  VerifyEmailUseCase(this.repo);

  Future<Either<Failure, bool>> call({required String email}) {
    return repo.forgotPassword(email);
  }
}