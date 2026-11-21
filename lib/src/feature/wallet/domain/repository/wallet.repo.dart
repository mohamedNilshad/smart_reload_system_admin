import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';

abstract class WalletRepo {
  Future<Either<Failure, double>> getWalletSummary();
  Future<Either<Failure, List<ComWithdrawHistoryEntity>>> getHistory();
  Future<Either<Failure, bool>> addWithdrawal({required double withdrewAmount, required double totalAmount, required String bankId});
  Future<Either<Failure, List<BankDetailsModel>>> getVendorBankInfo();
  Future<Either<Failure, BankDetailsModel>> addNewBankInfo({required BankDetailsModel bankDetails});
  Future<Either<Failure, bool>> removeBankInfo({required String bankDetailsId});

}
