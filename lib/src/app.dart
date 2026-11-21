import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';
import 'package:smart_reload_system_admin/src/core/presentation/screens/no_internet_banner.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/core/router/route.dart';
import 'package:smart_reload_system_admin/src/core/theme/theme.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/navigator_key.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.bloc.dart';
import 'package:smart_reload_system_admin/src/injection_container.dart';

class App extends StatelessWidget {
  final ThemeMode theme;
  const App({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<SessionCubit>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
        BlocProvider(create: (_) => sl<NewsBloc>()),
        BlocProvider(create: (_) => sl<PackageBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
      ],
      child: MaterialApp(
        builder: (context, child) => NoInternetBanner(child: child!),
        navigatorKey: navigatorKey,
        title: AppStrings.brandName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        //themeMode: state,
        themeMode: ThemeMode.dark,
        initialRoute: RouteConstants.splashScreen,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
