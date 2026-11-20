import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthLogoutSuccess extends AuthState {}

class ReauthenticationSuccess extends AuthState {}

class AuthVerifyEmailSuccess extends AuthState {
  final bool value;
  const AuthVerifyEmailSuccess(this.value);

  @override
  List<Object> get props => [value];
}

class AuthFailureState extends AuthState {
 final String message;
 const AuthFailureState(this.message);
 @override
 List<Object> get props => [message];
}