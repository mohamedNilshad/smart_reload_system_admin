import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_summary.entity.g.dart';

@JsonSerializable()
class WalletSummaryEntity extends Equatable {
  final String vendorId;
  final double currentBalance;
  final double totalPaid;
  final double totalCommission;
  final int activeClients;
  final int paidInvoices;

  const WalletSummaryEntity({
    required this.vendorId,
    required this.currentBalance,
    required this.totalPaid,
    required this.totalCommission,
    required this.activeClients,
    required this.paidInvoices,
  });

  factory WalletSummaryEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletSummaryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSummaryEntityToJson(this);

  @override
  List<Object?> get props => [
    vendorId,
    currentBalance,
    totalPaid,
    totalCommission,
    activeClients,
    paidInvoices,
  ];
}
