import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class GetCachedUserUseCase {
  final AuthRepo repo;
  GetCachedUserUseCase(this.repo);

  Future<UserEntity?> call() => repo.getCachedUser();
}