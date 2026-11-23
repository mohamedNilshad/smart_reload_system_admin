import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';

class GetCommissionUseCase {
  final SystemRepo repo;
  GetCommissionUseCase(this.repo);

  Future<Either<Failure, Map<String, dynamic>>> call(){
    return repo.getCommission();
  }
}
