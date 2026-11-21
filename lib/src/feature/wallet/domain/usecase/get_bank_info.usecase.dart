import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';

class GetBankInfoUseCase {
  final WalletRepo repo;

  GetBankInfoUseCase(this.repo);

  Future<Either<Failure, List<BankDetailsModel>>> call() {
    return repo.getVendorBankInfo();
  }
}
