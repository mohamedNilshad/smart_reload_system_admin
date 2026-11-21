import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_reload_system_admin/src/core/constants/constant.dart';
import 'package:smart_reload_system_admin/src/feature/auth/data/datasource/auth.local_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/auth/data/datasource/auth.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/auth/data/repositories/auth.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/repository/auth.repo.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/clear_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/get_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/login.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/logout.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/reauthenticate.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/update_cached_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/update_user_realtime.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/verify_email.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/usecase/watch_user_realtime.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/profile/data/datasource/profile.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/profile/data/repository/profile.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/repository/profile.repo.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_password.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_profile.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// External
  sl.registerLazySingleton(() => fb.FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseDatabase>(
        () => FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL),
  );

  sl.registerLazySingleton(() => const FlutterSecureStorage());
  // sl.registerLazySingleton(() => NotificationService());


  /// Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl(), database: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()));


  /// Repository
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteAuthDataSource: sl(), remoteDataSource: sl()),
  );

  /// Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => WatchUserRealtimeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserRealtimeUseCase(sl()));
  sl.registerLazySingleton(() => ClearCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => ReauthenticateUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));

  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  /// Bloc
  sl.registerLazySingleton(() => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      reauthenticateUseCase: sl(),
      verifyEmailUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SessionCubit(
      watchUserRealtimeUseCase: sl(),
      getCachedUserUseCase: sl(),
      firebaseAuth: sl(),
      logoutUseCase: sl(),
      updateCachedUserUseCase: sl(),
      clearCachedUserUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => ProfileBloc(
      updatePasswordUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );
}