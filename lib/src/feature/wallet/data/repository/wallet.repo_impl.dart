import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/datasource/wallet.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, double>> getWalletSummary() async {
    try {
      final summary = await remoteDataSource.getWalletSummary();
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ComWithdrawHistoryEntity>>>
  getHistory() async {
    try {
      final history = await remoteDataSource.getHistory();
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> addWithdrawal({required double withdrewAmount, required double totalAmount, required String bankId}) async {
    try {
      final saved = await remoteDataSource.addWithdrawal(
        withdrewAmount: withdrewAmount,
        totalAmount: totalAmount,
        bankId: bankId,
      );
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BankDetailsModel>>> getVendorBankInfo() async {
    try {
      final items = await remoteDataSource.getVendorBankInfo();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BankDetailsModel>> addNewBankInfo({required BankDetailsModel bankDetails}) async {
    try {
      final result = await remoteDataSource.addNewBankInfo(bankDetails: bankDetails);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBankInfo({required String bankDetailsId}) async {
    try {
      final result = await remoteDataSource.removeBankInfo(bankDetailsId: bankDetailsId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
