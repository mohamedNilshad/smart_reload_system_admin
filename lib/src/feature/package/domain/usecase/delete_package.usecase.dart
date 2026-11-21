import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/repository/package.repo.dart';

class DeletePackageUseCase {
  final PackageRepo repo;
  DeletePackageUseCase(this.repo);
  Future<Either<Failure, bool>> call(String packageId) => repo.deletePackage(packageId);
}
