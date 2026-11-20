import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';

class UpdateUserRealtimeUseCase {
  final AuthRepo repo;

  UpdateUserRealtimeUseCase(this.repo);

  Future<void> call(String uid, Map<String, dynamic> data) {
    return repo.updateUser(uid, data);
  }
}