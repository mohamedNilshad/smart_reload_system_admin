import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/watch_unread_count.usecase.dart';

class UnreadCountCubit extends Cubit<int> {
  final WatchUnreadCountUseCase watchUnreadCountUseCase;
  final fb.FirebaseAuth firebaseAuth;

  StreamSubscription? _authSub;
  StreamSubscription<int>? _countSub;

  UnreadCountCubit({
    required this.watchUnreadCountUseCase,
    required this.firebaseAuth,
  }) : super(0) {
    _authSub = firebaseAuth.authStateChanges().listen((user) {
      _countSub?.cancel();
      if (user == null) {
        emit(0);
        return;
      }
      _countSub = watchUnreadCountUseCase(user.uid).listen((count) {
        if (!isClosed) emit(count);
      });
    });
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _countSub?.cancel();
    return super.close();
  }
}