// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_withdrew_history.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComWithdrawHistoryEntity _$ComWithdrawHistoryEntityFromJson(
  Map<String, dynamic> json,
) => ComWithdrawHistoryEntity(
  vendorId: json['vendorId'] as String,
  withdrewAmount: (json['withdrewAmount'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  bankId: json['bankId'] as String,
);

Map<String, dynamic> _$ComWithdrawHistoryEntityToJson(
  ComWithdrawHistoryEntity instance,
) => <String, dynamic>{
  'vendorId': instance.vendorId,
  'withdrewAmount': instance.withdrewAmount,
  'totalAmount': instance.totalAmount,
  'date': instance.date.toIso8601String(),
  'bankId': instance.bankId,
};
