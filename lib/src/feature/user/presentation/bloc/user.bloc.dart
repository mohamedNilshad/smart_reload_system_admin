import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/add_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/delete_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/get_users.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/update_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.event.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final AddUserUseCase addUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UserBloc({
    required this.getUsersUseCase,
    required this.addUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(const UserInitial()) {
    on<GetUsersRequested>(_onGetUsersRequested);
    on<AddUserRequested>(_onAddUserRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
  }

  Future<void> _onGetUsersRequested(
    GetUsersRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(isFetching: true));
    final result = await getUsersUseCase();
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _onAddUserRequested(
    AddUserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    final result = await addUserUseCase(event.user);
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (_) => emit(const UserSuccess()),
    );
  }

  Future<void> _onUpdateUserRequested(
    UpdateUserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    final result = await updateUserUseCase(event.user);
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (_) => emit(const UserSuccess()),
    );
  }

  Future<void> _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    final result = await deleteUserUseCase(event.userId);
    result.fold(
      (failure) => emit(UserFailure(failure.message)),
      (_) => emit(const UserDeleteSuccess()),
    );
  }
}
