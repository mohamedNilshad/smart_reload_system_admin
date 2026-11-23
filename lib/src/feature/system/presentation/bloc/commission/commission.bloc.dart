import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/commission/commission.event.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/commission/commission.state.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/update_commission.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/get_commission.usecase.dart';

class CommissionBloc extends Bloc<CommissionEvent, CommissionState> {
  final UpdateCommissionUseCase updateCommissionUseCase;
  final GetCommissionUseCase getCommissionUseCase;

  CommissionBloc({
    required this.updateCommissionUseCase,
    required this.getCommissionUseCase,
  }) : super(const CommissionInitial()) {
    on<UpdateCommissionRequested>(_onUpdateRequested);
    on<GetCommissionRequested>(_onGetCommissionRequested);
    on<CommissionReset>(_onReset);
  }

  Future<void> _onUpdateRequested(UpdateCommissionRequested event, Emitter<CommissionState> emit) async {
    emit(const CommissionLoading(isUpdating: true));
    final result = await updateCommissionUseCase(event.adminCommission, event.vendorCommission);
    result.fold((failure) => emit(CommissionFailure(failure.message)), (_) {
      emit(const CommissionSuccess());
    });
  }

  Future<void> _onReset(CommissionReset event, Emitter<CommissionState> emit) async {
    emit(const CommissionInitial());
  }

  Future<void> _onGetCommissionRequested(GetCommissionRequested event, Emitter<CommissionState> emit) async {
    emit(const CommissionLoading(isFetching: true));
    final result = await getCommissionUseCase();
    result.fold((failure) => emit(CommissionFailure(failure.message)), (commission) {
      emit(CommissionLoaded(adminCommission: commission['adminCommission'], vendorCommission: commission['vendorCommission']));
    });
  }

}
