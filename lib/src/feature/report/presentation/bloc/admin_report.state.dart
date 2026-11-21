import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';

abstract class AdminReportState extends Equatable {
  const AdminReportState();

  @override
  List<Object?> get props => [];
}

class AdminReportInitial extends AdminReportState {
  const AdminReportInitial();
}

class AdminReportLoading extends AdminReportState {
  const AdminReportLoading();
}

class AdminReportSuccess extends AdminReportState {
  final AdminReportSummaryEntity summary;

  const AdminReportSuccess(this.summary);

  @override
  List<Object?> get props => [summary];
}

class AdminReportFailureState extends AdminReportState {
  final String message;

  const AdminReportFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
