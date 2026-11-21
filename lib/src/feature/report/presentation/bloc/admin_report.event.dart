import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';

abstract class AdminReportEvent extends Equatable {
  const AdminReportEvent();

  @override
  List<Object?> get props => [];
}

class AdminReportRequested extends AdminReportEvent {
  final ReportPeriodEntity period;

  const AdminReportRequested({required this.period});

  @override
  List<Object?> get props => [period];
}

/// Clears state left over from an earlier visit (the bloc is an app-level
/// singleton).
class AdminReportReset extends AdminReportEvent {
  const AdminReportReset();
}
