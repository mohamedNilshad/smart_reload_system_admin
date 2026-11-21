import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';

class GetComWithdrawHistoryUseCase {
  final WalletRepo repo;

  GetComWithdrawHistoryUseCase(this.repo);

  Future<Either<Failure, List<ComWithdrawHistoryEntity>>> call() {
    return repo.getHistory();
  }
}
