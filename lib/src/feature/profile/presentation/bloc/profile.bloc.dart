import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_profile.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.event.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.state.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_password.usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  ProfileBloc({
    required this.updateProfileUseCase,
    required this.updatePasswordUseCase,
  }) : super(const ProfileInitial()) {
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<PasswordUpdateRequested>(_onUpdatePasswordRequested);
    on<ProfileReset>(_onReset);
  }

  Future<void> _onUpdateRequested(ProfileUpdateRequested event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    final result = await updateProfileUseCase(uid: event.userId, isEmailChanged: event.isEmailChanged, fullName: event.fullName, phoneNumber: event.phoneNumber, email: event.email, nic: event.nic);
    result.fold((failure) => emit(ProfileFailure(failure.message)), (_) {
      emit(const ProfileUpdateSuccess());
    });
  }

  Future<void> _onUpdatePasswordRequested(PasswordUpdateRequested event, Emitter<ProfileState> emit) async {
    emit(const PasswordLoading());
    final result = await updatePasswordUseCase(password: event.password);
    result.fold((failure) => emit(PasswordFailure(failure.message)), (_) {
      emit(const PasswordUpdateSuccess());
    });
  }

  Future<void> _onReset(ProfileReset event, Emitter<ProfileState> emit) async {
    emit(const ProfileInitial());
  }
}
