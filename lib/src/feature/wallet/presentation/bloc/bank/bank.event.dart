import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';

abstract class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class BankInfoRequested extends BankEvent {
  const BankInfoRequested();
}

class NewBankInfoRequested extends BankEvent {
  final BankDetailsModel bankDetailsModel;

  const NewBankInfoRequested({required this.bankDetailsModel});

  @override
  List<Object?> get props => [bankDetailsModel];
}

class RemoveBankInfoRequested extends BankEvent {
  final String bankDetailsId;

  const RemoveBankInfoRequested({required this.bankDetailsId});

  @override
  List<Object?> get props => [bankDetailsId];
}

class BankReset extends BankEvent {
  const BankReset();
}
