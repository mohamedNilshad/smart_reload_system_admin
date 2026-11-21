import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/usecase/get_admin_report.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.event.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.state.dart';

class AdminReportBloc extends Bloc<AdminReportEvent, AdminReportState> {
  final GetAdminReportUseCase getAdminReportUseCase;

  /// Lets a newer request win when the admin switches period quickly.
  int _requestId = 0;

  AdminReportBloc({required this.getAdminReportUseCase})
      : super(const AdminReportInitial()) {
    on<AdminReportRequested>(_onRequested);
    on<AdminReportReset>((_, emit) {
      _requestId++;
      emit(const AdminReportInitial());
    });
  }

  Future<void> _onRequested(
    AdminReportRequested event,
    Emitter<AdminReportState> emit,
  ) async {
    final id = ++_requestId;
    emit(const AdminReportLoading());

    final result = await getAdminReportUseCase(period: event.period);

    if (id != _requestId) return; // superseded by a newer request
    result.fold(
      (failure) => emit(AdminReportFailureState(failure.message)),
      (summary) => emit(AdminReportSuccess(summary)),
    );
  }
}
