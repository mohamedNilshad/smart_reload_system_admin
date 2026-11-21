import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';

abstract class AdminReportsRepo {
  Future<Either<Failure, AdminReportSummaryEntity>> getReport({
    required ReportPeriodEntity period,
  });
}
