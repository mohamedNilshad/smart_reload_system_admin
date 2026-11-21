import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';

abstract class ComHistoryState extends Equatable {
  const ComHistoryState();

  @override
  List<Object?> get props => [];
}

class ComHistoryInitial extends ComHistoryState {
  const ComHistoryInitial();
}

class ComHistoryLoading extends ComHistoryState {
  const ComHistoryLoading();
}

class ComHistoryFailure extends ComHistoryState {
  final String message;

  const ComHistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}


class WithdrawHistorySuccess extends ComHistoryState {
  final List<ComWithdrawHistoryEntity> history;

  const WithdrawHistorySuccess(this.history);

  @override
  List<Object?> get props => [history];
}
