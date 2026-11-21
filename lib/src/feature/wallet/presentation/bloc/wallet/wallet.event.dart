import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletRequested extends WalletEvent {
  const WalletRequested();
}

class WalletReset extends WalletEvent {
  const WalletReset();
}

class ComWithdrawalSubmitted extends WalletEvent {
  final double withdrewAmount;
  final double totalAmount;
  final String bankId;

  const ComWithdrawalSubmitted({required this.withdrewAmount, required this.totalAmount, required this.bankId});

  @override
  List<Object?> get props => [
    withdrewAmount,
    totalAmount,
    bankId,
  ];
}