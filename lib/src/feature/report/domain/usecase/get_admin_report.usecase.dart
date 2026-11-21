import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/repository/admin_reports.repo.dart';

class GetAdminReportUseCase {
  final AdminReportsRepo repo;
  GetAdminReportUseCase(this.repo);

  Future<Either<Failure, AdminReportSummaryEntity>> call({
    required ReportPeriodEntity period,
  }) {
    return repo.getReport(period: period);
  }
}
