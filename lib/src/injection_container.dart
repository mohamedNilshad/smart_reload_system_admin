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
import 'package:smart_reload_system_admin/src/feature/notification/data/datasource/notification.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/notification/data/repository/notification.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/repository/notification.repo.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/get_notifications.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/mark_all_as_read.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/mark_as_read.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/domain/usecase/watch_unread_count.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/data/datasource/profile.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/profile/data/repository/profile.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/repository/profile.repo.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_password.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/profile/domain/usecase/update_profile.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/datasource/system.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/repository/system.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/add_new_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/get_news_list.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// External
  sl.registerLazySingleton(() => fb.FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseDatabase>(
        () => FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL),
  );

  sl.registerLazySingleton(() => const FlutterSecureStorage());


  /// Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl(), database: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()));
  sl.registerLazySingleton<SystemRemoteDataSource>(() => SystemRemoteDataSourceImpl(sl()));


  /// Repository
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteAuthDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()));
  sl.registerLazySingleton<SystemRepo>(() => SystemRepoImpl(sl()));

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

  sl.registerLazySingleton(() => WatchUnreadCountUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));

  sl.registerLazySingleton(() => AddNewNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetNewsListUseCase(sl()));

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

  sl.registerLazySingleton(() => NotificationBloc(
      getNotificationsUseCase: sl(),
      markAsReadUseCase: sl(),
      markAllAsReadUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => NewsBloc(
    addNewNewsUseCase: sl(),
    getNewsListUseCase: sl(),
  ));
}