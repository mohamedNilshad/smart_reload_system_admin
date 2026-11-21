import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/add_com_withdrawal.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_wallet_summary.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletSummaryUseCase getWalletSummaryUseCase;
  final AddComWithdrawalUseCase addWithdrawalUseCase;

  WalletBloc({
    required this.getWalletSummaryUseCase,
    required this.addWithdrawalUseCase,
  }) : super(const WalletInitial()) {
    on<WalletRequested>(_onTotalRequested);
    on<ComWithdrawalSubmitted>(_onWithdrawalSubmitted);
    on<WalletReset>(_onWalletReset);
  }

  Future<void> _onTotalRequested(WalletRequested event, Emitter<WalletState> emit) async {
    emit(WalletLoading(isWalletLoading: true));

    final result = await getWalletSummaryUseCase();

    result.fold(
      (failure) => emit(WalletFailure(failure.message)),
      (totalBalance) => emit(WalletSuccess(totalBalance)),
    );
  }

  Future<void> _onWithdrawalSubmitted(ComWithdrawalSubmitted event, Emitter<WalletState> emit) async {
    emit(WalletLoading(isWithdrawalLoading: true));

    final result = await addWithdrawalUseCase(withdrewAmount: event.withdrewAmount, totalAmount: event.totalAmount, bankId: event.bankId);

    result.fold((failure) => emit(WalletFailure(failure.message)), (success) {
        emit(WithdrawSubmitted(success));
        add(const WalletRequested());
      },
    );
  }

  Future<void> _onWalletReset(WalletReset event, Emitter<WalletState> emit) async {
    emit(const WalletInitial());
  }
}
