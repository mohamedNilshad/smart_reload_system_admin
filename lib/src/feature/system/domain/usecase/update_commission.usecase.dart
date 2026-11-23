import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';

class UpdateCommissionUseCase {
  final SystemRepo repo;
  UpdateCommissionUseCase(this.repo);

  Future<Either<Failure, bool>> call(String adminCommission, String vendorCommission){
    return repo.updateCommission(adminCommission, vendorCommission);
  }
}
