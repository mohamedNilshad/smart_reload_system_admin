import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_reload_system_admin/src/core/constants/constant.dart';
import 'package:smart_reload_system_admin/src/core/services/admin_report_calculator.service.dart';
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
import 'package:smart_reload_system_admin/src/feature/report/data/datasource/admin_reports.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/report/data/repository/admin_reports.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/repository/admin_reports.repo.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/usecase/get_admin_report.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/datasource/system.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/repository/system.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/add_new_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/delete_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/get_news_list.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/update_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/package/data/datasource/package.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/package/data/repository/package.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/repository/package.repo.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/add_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/delete_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/get_packages.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/update_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/user/data/datasource/user.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/user/data/repository/user.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/repository/user.repo.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/add_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/delete_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/get_users.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/usecase/update_user.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/datasource/wallet.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/repository/wallet.repo_impl.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/repository/wallet.repo.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/add_com_withdrawal.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_bank_info.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_com_withdrew_history.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/get_wallet_summary.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/new_bank_info.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/usecase/remove_bank_info.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.bloc.dart';

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
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      database: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<SystemRemoteDataSource>(
    () => SystemRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PackageRemoteDataSource>(
    () => PackageRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
  );

  sl.registerLazySingleton(() => AdminReportsRemoteDataSource());
  sl.registerLazySingleton(() => const AdminReportCalculator());

  /// Repository
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteAuthDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()));
  sl.registerLazySingleton<SystemRepo>(() => SystemRepoImpl(sl()));
  sl.registerLazySingleton<PackageRepo>(() => PackageRepoImpl(sl()));
  sl.registerLazySingleton<WalletRepo>(() => WalletRepoImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(sl()));
  sl.registerLazySingleton<AdminReportsRepo>(() => AdminReportsRepoImpl(remote: sl(), calculator: sl()));

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
  sl.registerLazySingleton(() => UpdateNewsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetPackagesUseCase(sl()));
  sl.registerLazySingleton(() => AddPackageUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePackageUseCase(sl()));
  sl.registerLazySingleton(() => DeletePackageUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => AddUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));

  sl.registerLazySingleton(() => AddComWithdrawalUseCase(sl()));
  sl.registerLazySingleton(() => GetComWithdrawHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetBankInfoUseCase(sl()));
  sl.registerLazySingleton(() => NewBankInfoUseCase(sl()));
  sl.registerLazySingleton(() => RemoveBankInfoUseCase(sl()));

  sl.registerLazySingleton(() => GetAdminReportUseCase(sl()));

  /// Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      reauthenticateUseCase: sl(),
      verifyEmailUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SessionCubit(
      watchUserRealtimeUseCase: sl(),
      getCachedUserUseCase: sl(),
      firebaseAuth: sl(),
      logoutUseCase: sl(),
      updateCachedUserUseCase: sl(),
      clearCachedUserUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ProfileBloc(updatePasswordUseCase: sl(), updateProfileUseCase: sl()),
  );

  sl.registerLazySingleton(
    () => NotificationBloc(
      getNotificationsUseCase: sl(),
      markAsReadUseCase: sl(),
      markAllAsReadUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NewsBloc(
      addNewNewsUseCase: sl(),
      getNewsListUseCase: sl(),
      updateNewsUseCase: sl(),
      deleteNewsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => PackageBloc(
      getPackagesUseCase: sl(),
      addPackageUseCase: sl(),
      updatePackageUseCase: sl(),
      deletePackageUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UserBloc(
      getUsersUseCase: sl(),
      addUserUseCase: sl(),
      updateUserUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => WalletBloc(
      getWalletSummaryUseCase: sl(),
      addWithdrawalUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => BankBloc(
      removeBankInfoUseCase: sl(),
      getVendorBankInfoUseCase: sl(),
      newBankInfoUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => ComHistoryBloc(getHistoryUseCase: sl()));

  sl.registerLazySingleton(() => AdminReportBloc(getAdminReportUseCase: sl()));

}
