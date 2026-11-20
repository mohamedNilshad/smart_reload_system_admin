import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/login.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/logout.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/reauthenticate.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/verify_email.usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final ReauthenticateUseCase reauthenticateUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.reauthenticateUseCase,
    required this.verifyEmailUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<ReauthenticateRequested>(_onReauthenticate);
    on<VerifyEmailRequested>(_onVerifyEmail);
    on<AuthReset>(_onReset);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(email: event.email, password: event.password);
    result.fold(
          (failure) => emit(AuthFailureState(failure.message)),
          (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onVerifyEmail(VerifyEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyEmailUseCase(email: event.email);
    result.fold(
          (failure) => emit(AuthFailureState(failure.message)),
          (value) => emit(AuthVerifyEmailSuccess(value)),
    );
  }

  Future<void> _onReauthenticate(ReauthenticateRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await reauthenticateUseCase(event.password);
    result.fold(
          (failure) => emit(AuthFailureState(failure.message)),
          (_) => emit(ReauthenticationSuccess()),
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }

  Future<void> _onReset(AuthReset event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }
}