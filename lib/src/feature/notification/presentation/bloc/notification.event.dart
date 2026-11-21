import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class NotificationListRequested extends NotificationEvent {
  final String uid;
  const NotificationListRequested(this.uid);
  @override
  List<Object> get props => [uid];
}

class NotificationMarkAsReadRequested extends NotificationEvent {
  final String uid;
  final String notificationId;
  const NotificationMarkAsReadRequested({required this.uid, required this.notificationId});
  @override
  List<Object> get props => [uid, notificationId];
}

class NotificationMarkAllAsReadRequested extends NotificationEvent {
  final String uid;
  const NotificationMarkAllAsReadRequested(this.uid);
  @override
  List<Object> get props => [uid];
}