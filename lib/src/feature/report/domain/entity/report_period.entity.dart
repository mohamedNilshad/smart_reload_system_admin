import 'package:equatable/equatable.dart';

/// A reporting window made of whole calendar days. [from] is inclusive and
/// [to] is exclusive, both at local midnight.
class ReportPeriodEntity extends Equatable {
  final DateTime from;
  final DateTime to;
  final String label;

  const ReportPeriodEntity({
    required this.from,
    required this.to,
    required this.label,
  });

  factory ReportPeriodEntity.today([DateTime? now]) {
    final n = now ?? DateTime.now();
    return ReportPeriodEntity(
      from: DateTime(n.year, n.month, n.day),
      to: DateTime(n.year, n.month, n.day + 1),
      label: 'Today',
    );
  }

  factory ReportPeriodEntity.lastDays(int days, [DateTime? now]) {
    final n = now ?? DateTime.now();
    return ReportPeriodEntity(
      from: DateTime(n.year, n.month, n.day - (days - 1)),
      to: DateTime(n.year, n.month, n.day + 1),
      label: '$days days',
    );
  }

  /// From the 1st of the current month until today.
  factory ReportPeriodEntity.thisMonth([DateTime? now]) {
    final n = now ?? DateTime.now();
    return ReportPeriodEntity(
      from: DateTime(n.year, n.month, 1),
      to: DateTime(n.year, n.month, n.day + 1),
      label: 'This month',
    );
  }

  /// [endInclusive] is the last day that is part of the period.
  factory ReportPeriodEntity.custom(DateTime start, DateTime endInclusive) {
    return ReportPeriodEntity(
      from: DateTime(start.year, start.month, start.day),
      to: DateTime(endInclusive.year, endInclusive.month, endInclusive.day + 1),
      label: 'Custom',
    );
  }

  /// Number of calendar days in the period.
  int get days => DateTime.utc(to.year, to.month, to.day)
      .difference(DateTime.utc(from.year, from.month, from.day))
      .inDays;

  /// Start of the equally long period that comes right before this one.
  DateTime get previousFrom => DateTime(from.year, from.month, from.day - days);

  @override
  List<Object?> get props => [from, to, label];
}
