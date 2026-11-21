
import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/presentation/screens/main.screen.dart';
import 'package:smart_reload_system_admin/src/core/presentation/screens/splash.screen.dart';
import 'package:smart_reload_system_admin/src/core/presentation/screens/unknown.screen.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/feature/System/presentation/screen/news_banner.screen.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/screens/login.screen.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/screens/forgot_password.screen.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/screen/packages.screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint("Navigating to ${settings.name}");
    switch (settings.name) {
      case RouteConstants.splashScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.splashScreen),
          builder: (context) => const SplashScreen(),
        );

      case RouteConstants.loginScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.loginScreen),
          builder: (context) => const LoginScreen(),
        );

      case RouteConstants.forgotPasswordScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.forgotPasswordScreen),
          builder: (context) => const ForgotPasswordScreen(),
        );

      case RouteConstants.mainScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.mainScreen),
          builder: (context) => const MainScreen(),
        );

      case RouteConstants.packagesScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.packagesScreen),
          builder: (context) => const PackagesScreen(),
        );

      case RouteConstants.newsBannerScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RouteConstants.newsBannerScreen),
          builder: (context) => const NewsBannerScreen(),
        );

      // case RouteConstants.commissionScreen:
      //   return MaterialPageRoute(
      //     settings: const RouteSettings(name: RouteConstants.commissionScreen),
      //     builder: (context) => const CommissionScreen(),
      //   );


    }

    assert(false, 'Need to implement ${settings.name}');
    return MaterialPageRoute(builder: (_) => const UnknownScreen());
  }
}

class MenuSlideUpRoute<T> extends MaterialPageRoute<T> {
  MenuSlideUpRoute(
      {required super.builder, required RouteSettings super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
