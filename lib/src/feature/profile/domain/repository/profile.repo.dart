import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';

abstract class ProfileRepo {
  Future<Either<Failure, void>> updateProfile({required String uid, required bool isEmailChanged, required String fullName, required String phoneNumber, required String email, required String nic});
  Future<Either<Failure, void>> updatePassword({required String password});
}
