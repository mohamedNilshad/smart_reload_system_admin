import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/package/data/datasource/package.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/repository/package.repo.dart';

class PackageRepoImpl implements PackageRepo {
  final PackageRemoteDataSource remoteDataSource;
  PackageRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    try { return Right(await remoteDataSource.getPackages()); } on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }

  @override
  Future<Either<Failure, bool>> addPackage(PackageEntity package) async {
    try { return Right(await remoteDataSource.addPackage(package)); } on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }

  @override
  Future<Either<Failure, bool>> updatePackage(PackageEntity package) async {
    try { return Right(await remoteDataSource.updatePackage(package)); } on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }

  @override
  Future<Either<Failure, bool>> deletePackage(String packageId) async {
    try { return Right(await remoteDataSource.deletePackage(packageId)); } on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }
}
