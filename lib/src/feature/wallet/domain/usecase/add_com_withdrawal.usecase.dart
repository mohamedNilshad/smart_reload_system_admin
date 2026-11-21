import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';

class AddComWithdrawalUseCase {
  final WalletRepo repo;

  AddComWithdrawalUseCase(this.repo);

  Future<Either<Failure, bool>> call({required double withdrewAmount, required double totalAmount, required String bankId}) {
    return repo.addWithdrawal(withdrewAmount: withdrewAmount, totalAmount: totalAmount, bankId: bankId);
  }
}
