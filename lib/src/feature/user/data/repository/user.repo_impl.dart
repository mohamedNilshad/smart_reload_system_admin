import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/user/data/datasource/user.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/repository/user.repo.dart';

class UserRepoImpl implements UserRepo {
  final UserRemoteDataSource remoteDataSource;
  UserRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AdminUserEntity>>> getUsers() async {
    try {
      return Right(await remoteDataSource.getUsers());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> addUser(AdminUserEntity user) async {
    try {
      return Right(await remoteDataSource.addUser(user));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(AdminUserEntity user) async {
    try {
      return Right(await remoteDataSource.updateUser(user));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(String userId) async {
    try {
      return Right(await remoteDataSource.deleteUser(userId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
