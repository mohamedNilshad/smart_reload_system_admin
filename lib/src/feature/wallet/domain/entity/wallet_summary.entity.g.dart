// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_summary.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletSummaryEntity _$WalletSummaryEntityFromJson(Map<String, dynamic> json) =>
    WalletSummaryEntity(
      vendorId: json['vendorId'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      totalPaid: (json['totalPaid'] as num).toDouble(),
      totalCommission: (json['totalCommission'] as num).toDouble(),
      activeClients: (json['activeClients'] as num).toInt(),
      paidInvoices: (json['paidInvoices'] as num).toInt(),
    );

Map<String, dynamic> _$WalletSummaryEntityToJson(
  WalletSummaryEntity instance,
) => <String, dynamic>{
  'vendorId': instance.vendorId,
  'currentBalance': instance.currentBalance,
  'totalPaid': instance.totalPaid,
  'totalCommission': instance.totalCommission,
  'activeClients': instance.activeClients,
  'paidInvoices': instance.paidInvoices,
};
