import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class UpdateCachedUserUseCase {
  final AuthRepo repo;
  UpdateCachedUserUseCase(this.repo);

  Future<void> call(UserEntity user) => repo.updateCachedUser(user);
}