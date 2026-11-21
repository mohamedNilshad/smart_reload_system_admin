import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_com_withdrew_history.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.state.dart';

class ComHistoryBloc extends Bloc<ComHistoryEvent, ComHistoryState> {
  final GetComWithdrawHistoryUseCase getHistoryUseCase;

  ComHistoryBloc({required this.getHistoryUseCase}) : super(const ComHistoryInitial()) {
    on<ComWithdrawHistoryRequested>(_onHistoryRequested);
    on<ComHistoryReset>(_onComHistoryReset);
  }

  Future<void> _onHistoryRequested(ComWithdrawHistoryRequested event, Emitter<ComHistoryState> emit) async {
    emit(ComHistoryLoading());

    final result = await getHistoryUseCase();

    result.fold(
          (failure) => emit(ComHistoryFailure(failure.message)),
          (history) => emit(WithdrawHistorySuccess(history)),
    );
  }


  Future<void> _onComHistoryReset(ComHistoryReset event, Emitter<ComHistoryState> emit) async {
    emit(const ComHistoryInitial());
  }
}
