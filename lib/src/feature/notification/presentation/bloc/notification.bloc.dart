import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/get_notifications.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/mark_all_as_read.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/mark_as_read.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.event.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<NotificationListRequested>(_onListRequested);
    on<NotificationMarkAsReadRequested>(_onMarkAsRead);
    on<NotificationMarkAllAsReadRequested>(_onMarkAllAsRead);
  }

  Future<void> _onListRequested(
      NotificationListRequested event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase(event.uid);
    result.fold(
          (failure) => emit(NotificationFailureState(failure.message)),
          (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> _onMarkAsRead(
      NotificationMarkAsReadRequested event,
      Emitter<NotificationState> emit,
      ) async {
    await markAsReadUseCase(uid: event.uid, notificationId: event.notificationId);
    // Refresh the list to reflect the change; UnreadCountCubit updates itself
    // independently via its own live listener.
    add(NotificationListRequested(event.uid));
  }

  Future<void> _onMarkAllAsRead(
      NotificationMarkAllAsReadRequested event,
      Emitter<NotificationState> emit,
      ) async {
    await markAllAsReadUseCase(event.uid);
    add(NotificationListRequested(event.uid));
  }
}