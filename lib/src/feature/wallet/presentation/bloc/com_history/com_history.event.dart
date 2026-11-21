import 'package:equatable/equatable.dart';

abstract class ComHistoryEvent extends Equatable {
  const ComHistoryEvent();

  @override
  List<Object?> get props => [];
}

class ComHistoryReset extends ComHistoryEvent {
  const ComHistoryReset();
}

class ComWithdrawHistoryRequested extends ComHistoryEvent {
  const ComWithdrawHistoryRequested();
}

