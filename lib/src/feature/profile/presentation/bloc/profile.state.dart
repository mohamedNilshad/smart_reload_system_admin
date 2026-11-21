import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

///Profile
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}


class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess();
}

///Password

class PasswordLoading extends ProfileState {
  const PasswordLoading();
}

class PasswordFailure extends ProfileState {
  final String message;
  const PasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordUpdateSuccess extends ProfileState {
  const PasswordUpdateSuccess();
}
