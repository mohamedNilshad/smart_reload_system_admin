
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class ClearCachedUserUseCase {
  final AuthRepo repo;
  ClearCachedUserUseCase(this.repo);

  Future<void> call() => repo.clearCachedUser();
}