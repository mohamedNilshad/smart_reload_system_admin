import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class WatchUserRealtimeUseCase {
  final AuthRepo repo;
  WatchUserRealtimeUseCase(this.repo);

  Stream<UserEntity?> call(String uid) {
    return repo.watchUser(uid);
  }
}