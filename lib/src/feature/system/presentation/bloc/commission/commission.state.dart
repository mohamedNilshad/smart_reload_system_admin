import 'package:equatable/equatable.dart';

abstract class CommissionState extends Equatable {
  const CommissionState();

  @override
  List<Object?> get props => [];
}

class CommissionInitial extends CommissionState {
  const CommissionInitial();
}

class CommissionLoading extends CommissionState {
  final bool isUpdating;
  final bool isFetching;

  const CommissionLoading({this.isUpdating = false, this.isFetching = false});
  @override
  List<Object?> get props => [isUpdating, isFetching];
}

class CommissionLoaded extends CommissionState {
  final String adminCommission;
  final String vendorCommission;
  const CommissionLoaded({required this.adminCommission, required this.vendorCommission});

  @override
  List<Object?> get props => [adminCommission, vendorCommission];
}

class CommissionFailure extends CommissionState {
  final String message;
  const CommissionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CommissionSuccess extends CommissionState {
  const CommissionSuccess();
}

