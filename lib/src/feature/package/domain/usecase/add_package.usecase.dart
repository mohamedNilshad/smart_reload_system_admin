import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/repository/package.repo.dart';

class AddPackageUseCase {
  final PackageRepo repo;
  AddPackageUseCase(this.repo);
  Future<Either<Failure, bool>> call(PackageEntity package) => repo.addPackage(package);
}
