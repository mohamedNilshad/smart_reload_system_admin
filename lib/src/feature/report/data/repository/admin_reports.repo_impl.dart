import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/core/services/admin_report_calculator.service.dart';
import 'package:smart_reload_system_admin/src/feature/report/data/datasource/admin_reports.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/repository/admin_reports.repo.dart';

class AdminReportsRepoImpl implements AdminReportsRepo {
  final AdminReportsRemoteDataSource remote;
  final AdminReportCalculator calculator;

  AdminReportsRepoImpl({required this.remote, required this.calculator});

  @override
  Future<Either<Failure, AdminReportSummaryEntity>> getReport({
    required ReportPeriodEntity period,
  }) async {
    try {
      final source = await remote.fetch(
        from: period.previousFrom, // also load the previous period to compare
        to: period.to,
      );
      return Right(
        calculator.build(source: source, period: period, now: DateTime.now()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
