import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';

abstract class PackageRepo {
  Future<Either<Failure, List<PackageEntity>>> getPackages();
  Future<Either<Failure, bool>> addPackage(PackageEntity package);
  Future<Either<Failure, bool>> updatePackage(PackageEntity package);
  Future<Either<Failure, bool>> deletePackage(String packageId);
}
