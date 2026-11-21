import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commission_withdrew_history.entity.g.dart';

@JsonSerializable()
class ComWithdrawHistoryEntity extends Equatable {
  final String vendorId;
  final double withdrewAmount;
  final double totalAmount;
  final DateTime date;
  final String bankId;

  const ComWithdrawHistoryEntity({
    required this.vendorId,
    required this.withdrewAmount,
    required this.totalAmount,
    required this.date,
    required this.bankId
  });

  factory ComWithdrawHistoryEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComWithdrawHistoryEntity(
      vendorId: data['vendorId'] as String? ?? '',
      withdrewAmount: (data['withdrewAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bankId: data['bankId'] as String? ?? '',
    );
  }

  factory ComWithdrawHistoryEntity.fromJson(Map<String, dynamic> json) =>
      _$ComWithdrawHistoryEntityFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ComWithdrawHistoryEntityToJson(this);

  @override
  List<Object?> get props => [
    vendorId,
    withdrewAmount,
    totalAmount,
    date,
    bankId,
  ];
}
