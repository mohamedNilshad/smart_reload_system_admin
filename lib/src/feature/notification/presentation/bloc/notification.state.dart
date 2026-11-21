import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/entity/notification.entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  const NotificationLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

class NotificationFailureState extends NotificationState {
  final String message;
  const NotificationFailureState(this.message);
  @override
  List<Object?> get props => [message];
}