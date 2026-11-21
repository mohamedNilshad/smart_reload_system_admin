import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/repository/profile.repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo repo;
  UpdateProfileUseCase(this.repo);

  Future<Either<Failure, void>> call({required String uid, required bool isEmailChanged, required String fullName, required String phoneNumber, required String email, required String nic}){
    return repo.updateProfile(uid: uid, isEmailChanged: isEmailChanged, fullName: fullName, phoneNumber: phoneNumber, email: email, nic: nic);
  }
}
