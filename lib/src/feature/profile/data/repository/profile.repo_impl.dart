import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/auth/data/datasource/auth.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/profile/data/datasource/profile.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/repository/profile.repo.dart';
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthRemoteDataSource remoteAuthDataSource;

  ProfileRepoImpl({required this.remoteDataSource, required this.remoteAuthDataSource});

  @override
  Future<Either<Failure, void>> updateProfile({required String uid, required bool isEmailChanged, required String fullName, required String phoneNumber, required String email, required String nic}) async {
    try {
      await remoteDataSource.updateProfile(userId: uid, isEmailChanged: isEmailChanged, fullName: fullName, phoneNumber: phoneNumber, email: email, nic: nic);
      final data =  {
        'updatedOn': DateTime.now().toIso8601String(),
        'updateType': 1,///-1-null, 0-disable, 1-profile
      };
      await remoteAuthDataSource.updateUser(uid, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({required String password}) async {
    try {
      await remoteDataSource.updatePassword(password: password);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
