import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUsersRequested extends UserEvent {
  const GetUsersRequested();
}

class AddUserRequested extends UserEvent {
  final AdminUserEntity user;

  const AddUserRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserRequested extends UserEvent {
  final AdminUserEntity user;

  const UpdateUserRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserRequested extends UserEvent {
  final String userId;

  const DeleteUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
