import 'package:equatable/equatable.dart';

/// One package request joined with its package and connection, flattened to
/// what the admin reports need.
class AdminReportRowEntity extends Equatable {
  final String id;
  final String vendorId;
  final String connectionId;
  final String provider;
  final String packageName;
  final DateTime requestDate;
  final double amount;
  final bool isPaid;

  /// Commission rate saved on the request when it was made, if any. When
  /// null, the current rate from the system settings is used.
  final double? commissionPercent;

  const AdminReportRowEntity({
    required this.id,
    required this.vendorId,
    required this.connectionId,
    required this.provider,
    required this.packageName,
    required this.requestDate,
    required this.amount,
    required this.isPaid,
    this.commissionPercent,
  });

  @override
  List<Object?> get props => [
        id,
        vendorId,
        connectionId,
        provider,
        packageName,
        requestDate,
        amount,
        isPaid,
        commissionPercent,
      ];
}

/// Everything loaded from Firestore for one dashboard refresh.
class AdminReportSourceEntity extends Equatable {
  /// Requests of the period and the previous period, plus every unpaid one.
  final List<AdminReportRowEntity> rows;

  /// vendor user id -> display name.
  final Map<String, String> vendorNames;
  final int vendorCount;
  final int clientCount;
  final int connectionCount;

  /// Current commission percentage from the system settings (0 if unset).
  final double commissionPercent;

  const AdminReportSourceEntity({
    required this.rows,
    required this.vendorNames,
    required this.vendorCount,
    required this.clientCount,
    required this.connectionCount,
    required this.commissionPercent,
  });

  @override
  List<Object?> get props => [
        rows,
        vendorNames,
        vendorCount,
        clientCount,
        connectionCount,
        commissionPercent,
      ];
}
