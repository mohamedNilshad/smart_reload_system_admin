import 'package:equatable/equatable.dart';

class BankDetailsModel extends Equatable {
  final String? id;
  final String accountHolderName;
  final String vendorId;
  final String bankName;
  final String bankCode;
  final String branchName;
  final String branchCode;
  final String accountNumber;
  final String accountType;
  final DateTime updatedAt;
  final bool isDeleted;

  const BankDetailsModel({
    this.id,
    required this.accountHolderName,
    required this.vendorId,
    required this.bankName,
    required this.bankCode,
    required this.branchName,
    required this.branchCode,
    required this.accountNumber,
    required this.accountType,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return BankDetailsModel(
      id: id ?? json['id'] as String?,
      accountHolderName: json['accountHolderName'] as String,
      vendorId: json['vendorId'] as String,
      bankName: json['bankName'] as String,
      bankCode: json['bankCode'] as String,
      branchName: json['branchName'] as String,
      branchCode: json['branchCode'] as String,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'vendorId': vendorId,
    'bankName': bankName,
    'bankCode': bankCode,
    'branchName': branchName,
    'branchCode': branchCode,
    'accountNumber': accountNumber,
    'accountType': accountType,
    'updatedAt': updatedAt.toIso8601String(),
    'isDeleted': isDeleted,
  };

  BankDetailsModel copyWith({String? id}) {
    return BankDetailsModel(
      id: id ?? this.id,
      accountHolderName: accountHolderName,
      vendorId: vendorId,
      bankName: bankName,
      bankCode: bankCode,
      branchName: branchName,
      branchCode: branchCode,
      accountNumber: accountNumber,
      accountType: accountType,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    accountHolderName,
    vendorId,
    bankName,
    bankCode,
    branchName,
    branchCode,
    accountNumber,
    accountType,
    updatedAt,
    isDeleted,
  ];
}