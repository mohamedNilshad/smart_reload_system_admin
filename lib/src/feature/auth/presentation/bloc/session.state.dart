import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';


abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

/// Still checking Firebase's persisted token — show a splash/loading screen.
class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final UserEntity user;
  const SessionAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class SessionUnauthenticated extends SessionState {}