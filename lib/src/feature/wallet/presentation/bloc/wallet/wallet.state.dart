import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  final bool isWalletLoading;
  final bool isWithdrawalLoading;
  const WalletLoading({this.isWalletLoading = false, this.isWithdrawalLoading = false});
}

class WalletSuccess extends WalletState {
  final double totalBalance;

  const WalletSuccess(this.totalBalance);

  @override
  List<Object?> get props => [totalBalance];
}

class WalletFailure extends WalletState {
  final String message;

  const WalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class WithdrawSubmitted extends WalletState {
  final bool success;

  const WithdrawSubmitted(this.success);

  @override
  List<Object?> get props => [success];
}



