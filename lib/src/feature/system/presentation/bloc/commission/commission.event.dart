import 'package:equatable/equatable.dart';

abstract class CommissionEvent extends Equatable {
  const CommissionEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCommissionRequested extends CommissionEvent {
  final String adminCommission;
  final String vendorCommission;

  const UpdateCommissionRequested({required this.adminCommission, required this.vendorCommission});

  @override
  List<Object?> get props => [adminCommission, vendorCommission];
}

class CommissionReset extends CommissionEvent {
  const CommissionReset();
}

class GetCommissionRequested extends CommissionEvent {
  const GetCommissionRequested();
}


