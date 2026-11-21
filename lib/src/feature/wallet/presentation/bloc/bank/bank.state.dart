import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';

abstract class BankState extends Equatable {
  const BankState();

  @override
  List<Object?> get props => [];
}

class BankInitial extends BankState {
  const BankInitial();
}

class BankLoading extends BankState {
  final bool isFetching;
  final bool isAdding;
  const BankLoading({this.isFetching = false, this.isAdding = false});
}

class BankSuccess extends BankState {
  final List<BankDetailsModel> items;

  const BankSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

class BankInfoRemoveSuccess extends BankState {
  final bool success;

  const BankInfoRemoveSuccess({required this.success});

  @override
  List<Object?> get props => [success];
}

class BankFailure extends BankState {
  final String message;

  const BankFailure(this.message);

  @override
  List<Object?> get props => [message];
}

