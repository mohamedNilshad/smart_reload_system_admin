import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/clear_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/get_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/logout.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/update_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/watch_user_realtime.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';

class SessionCubit extends Cubit<SessionState> {
  final FirebaseAuth firebaseAuth;
  final WatchUserRealtimeUseCase watchUserRealtimeUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final UpdateCachedUserUseCase updateCachedUserUseCase;
  final ClearCachedUserUseCase clearCachedUserUseCase;
  final LogoutUseCase logoutUseCase;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserEntity?>? _userSubscription;

  SessionCubit({
    required this.firebaseAuth,
    required this.watchUserRealtimeUseCase,
    required this.getCachedUserUseCase,
    required this.logoutUseCase,
    required this.updateCachedUserUseCase,
    required this.clearCachedUserUseCase,
  }) : super(SessionInitial()) {_start();}

  void _start() {
    _authSubscription = firebaseAuth.authStateChanges().listen((firebaseUser) {

      _userSubscription?.cancel();
      _userSubscription = null;

      if (firebaseUser == null) {
        clearCachedUserUseCase();

        if (!isClosed) emit(SessionUnauthenticated());

        return;
      }

      _listenToUser(firebaseUser.uid);
    });
  }

  void _listenToUser(String uid) {
    _userSubscription = watchUserRealtimeUseCase(uid).listen((data) async {

          if (data == null) return;

          final isActive = data.isActive ?? true;

          if (!isActive) {
            await _logoutBecauseDisabled(data);
            return;
          }

          await updateCachedUserUseCase(data);

          if (!isClosed) emit(SessionAuthenticated(data));
        });
  }

  Future<void> _logoutBecauseDisabled(UserEntity user) async {
    await _userSubscription?.cancel();
    _userSubscription = null;

    final result = await logoutUseCase();
    result.fold(
          (failure) => emit(SessionAuthenticated(user)),
          (_) => emit(SessionUnauthenticated()),
    );

  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await _authSubscription?.cancel();

    return super.close();
  }
}