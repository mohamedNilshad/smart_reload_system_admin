import 'package:smart_reload_system_admin/src/feature/notification/domain/repository/notification.repo.dart';
class WatchUnreadCountUseCase {
  final NotificationRepo repo;
  WatchUnreadCountUseCase(this.repo);

  Stream<int> call(String uid) => repo.watchUnreadCount(uid);
}