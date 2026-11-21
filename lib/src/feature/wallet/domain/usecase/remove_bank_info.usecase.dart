import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';

class RemoveBankInfoUseCase {
  final WalletRepo repo;

  RemoveBankInfoUseCase(this.repo);

  Future<Either<Failure, bool>> call({required String bankDetailsId}) {
    return repo.removeBankInfo(bankDetailsId: bankDetailsId);
  }
}
