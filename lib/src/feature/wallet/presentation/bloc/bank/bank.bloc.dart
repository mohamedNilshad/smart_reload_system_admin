import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_bank_info.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.state.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/new_bank_info.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/remove_bank_info.usecase.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final GetBankInfoUseCase getVendorBankInfoUseCase;
  final NewBankInfoUseCase newBankInfoUseCase;
  final RemoveBankInfoUseCase removeBankInfoUseCase;

  BankBloc({
    required this.getVendorBankInfoUseCase,
    required this.newBankInfoUseCase,
    required this.removeBankInfoUseCase,
  }) : super(const BankInitial()) {
    on<BankInfoRequested>(_onManageRequested);
    on<NewBankInfoRequested>(_onNewBankRequested);
    on<RemoveBankInfoRequested>(_onRemoveBankRequested);
    on<BankReset>(_onBankReset);
  }

  Future<void> _onManageRequested(BankInfoRequested event, Emitter<BankState> emit) async {
    emit(const BankLoading());

    final result = await getVendorBankInfoUseCase();

    result.fold(
      (failure) => emit(BankFailure(failure.message)),
      (items) => emit(BankSuccess(items)),
    );
  }

  Future<void> _onNewBankRequested(NewBankInfoRequested event, Emitter<BankState> emit) async {
    emit(const BankLoading());

    final result = await newBankInfoUseCase(bankDetails: event.bankDetailsModel);

    result.fold(
      (failure) => emit(BankFailure(failure.message)),
      (item) {
        emit(BankSuccess([item]));
        add(const BankInfoRequested());
      },
    );
  }

  Future<void> _onRemoveBankRequested(RemoveBankInfoRequested event, Emitter<BankState> emit) async {
    emit(const BankLoading());

    final result = await removeBankInfoUseCase(bankDetailsId: event.bankDetailsId);

    result.fold(
      (failure) => emit(BankFailure(failure.message)),
      (item) {
        emit(BankInfoRemoveSuccess(success: item));
        add(const BankInfoRequested());
      },
    );
  }

  Future<void> _onBankReset(
    BankReset event,
    Emitter<BankState> emit,
  ) async {
    emit(const BankInitial());
  }
}
