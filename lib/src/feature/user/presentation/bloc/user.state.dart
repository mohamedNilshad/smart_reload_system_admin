import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  final bool isFetching;

  const UserLoading({this.isFetching = false});

  @override
  List<Object?> get props => [isFetching];
}

class UserLoaded extends UserState {
  final List<AdminUserEntity> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserSuccess extends UserState {
  const UserSuccess();
}

class UserDeleteSuccess extends UserState {
  const UserDeleteSuccess();
}

class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);

  @override
  List<Object?> get props => [message];
}
