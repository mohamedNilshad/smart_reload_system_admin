import 'dart:io';

import 'package:smart_reload_system_admin/src/core/bloc/session/session.bloc.dart';
import 'package:smart_reload_system_admin/src/core/bloc/session/session.state.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/data/datasource/local_database_helper.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom.circular_progress_indicator.dart';
import 'package:smart_reload_system_admin/src/core/services/session.service.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/data/datasource/auth_local.datasource.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver, WindowListener {
  late final SessionManager _sessionManager;
  final DatabaseHelperDatasource _databaseHelperDatasource = sl<DatabaseHelperDatasource>();
  int currentIndex = 0;
  int currentSubMenuIndex = 0;
  bool isOrganizationExpanded = false;


  List<Widget> screens = [
    const TempScreen(title: "Dashboard"),//report
    const TempScreen(title: "Manage"),//manage(Service providers, packages, commission percentage, vendors and clients.)
    const TempScreen(title: "Wallet"),//wallet
    const TempScreen(title: "System"),//system
    const TempScreen(title: "Notification"),//notification
    const TempScreen(title: "Profile"),//profile
  ];

  List<Widget> orgScreens = [
    const TempScreen(title: "Service providers"),
    const TempScreen(title: "Packages"),
    const TempScreen(title: "Commission"),
    const TempScreen(title: "Users"),
  ];

  final List<String> titles = [
    "Dashboard",
    "Manage",
    "Wallet",
    "System",
    "Notification",
    "Profile",
  ];

  final List<IconData> icons = [
    Icons.dashboard,
    Icons.menu,
    Icons.monetization_on_outlined,
    Icons.miscellaneous_services_outlined,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];

  final List<String> organizationSubmenu = [
    "Service providers",
    "Packages",
    "Commission",
    "Users",
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      // This is the key state: app is going to the background
      //   debugPrint('AppLifecycleState: paused - Saving timestamp...');
        _saveCurrentTimestamp();
        break;
      case AppLifecycleState.resumed:
      // App is coming back to the foreground
      //   debugPrint('AppLifecycleState: resumed');
        _databaseHelperDatasource.isLoginSessionExpired();
        break;
      case AppLifecycleState.inactive:
      // _databaseHelperDatasource.isLoginSessionExpired();
        break;
      case AppLifecycleState.detached:
      // debugPrint('AppLifecycleState: detached');
      // On some platforms, detached might be the last chance, but paused is more common for "leaving foreground"
        break;
      case AppLifecycleState.hidden:
        debugPrint('AppLifecycleState: hidden');
        _saveCurrentTimestamp();
        break;
    }
  }

  Future<void> _saveCurrentTimestamp() async {
    final now = DateTime.now().toIso8601String();
    _databaseHelperDatasource.saveLocalData(key: AppStrings.lastClosedTimestampKey, value: now);
  }


  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    _sessionManager = sl<SessionManager>();
    _sessionManager.initialize();

    WidgetsBinding.instance.addObserver(this);
    _databaseHelperDatasource.isLoginSessionExpired();
    super.initState();
  }



  @override
  void onWindowClose() async {
    final AuthLocalDataSource localDataSource = sl<AuthLocalDataSource>();
    bool isLogeOut = await localDataSource.fetchUser() == null;

    if(isLogeOut && mounted){
      exit(0);
    }

    bool isPreventClose = await windowManager.isPreventClose();
    bool isLogouting = false;
    if (isPreventClose && mounted) {
      bool shouldClose = await showDialog(
        context: context,
        builder: (context) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                setState(() => isLogouting = state.isLogOuting);
              } else{
                setState(() => isLogouting = false);
              }
            },
            child: AlertDialog(
              title: const Text("Confirm Exit"),
              content: const Text("Are you sure you want to Logout and Close the app?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: isLogouting ? CCircularProgressIndicator(radius: 12.0,): const Text("Logout"),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent(context: context, isClose: true));
                  },
                ),
              ],
            ),
          );
        },
      ) ?? false;

      if (shouldClose) {
        await windowManager.destroy();
      }
    }
  }


  @override
  void dispose() {
    _sessionManager.dispose();
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    double screenWidth = HelperFunctions.screenWidth(context);
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionLoggedOut) {
          context.read<AuthBloc>().add(AuthLogoutEvent(context: context));
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: screenWidth / 7.5,
              color: isDark ? AppColors.shadowColor : AppColors.grey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Sizes.md),
                    child: Text(
                      AppStrings.brandName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: titles.length + (isOrganizationExpanded ? organizationSubmenu.length : 0),
                      itemBuilder: (context, index) {
                        if (index == 5) {
                          return ListTile(
                            leading: Icon(icons[index]),
                            title: Text(
                              titles[index],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            selected: isOrganizationExpanded,//index == currentIndex,
                            selectedTileColor: AppColors.primary,
                            titleTextStyle: Theme.of(context).textTheme.titleSmall,
                            onTap: () {
                              setState(() => isOrganizationExpanded = !isOrganizationExpanded);
                            },
                            trailing: Icon(isOrganizationExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          );
                        } else if (index > 5 && index < 5 + organizationSubmenu.length + 1 && isOrganizationExpanded) {

                          final submenuIndex = index - 6;
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ListTile(
                              title: Text(
                                organizationSubmenu[submenuIndex],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              titleTextStyle: Theme.of(context).textTheme.bodySmall,
                              selected: submenuIndex == currentSubMenuIndex,
                              selectedTileColor: AppColors.secondary,
                              onTap: () {
                                debugPrint("Tapped on ${organizationSubmenu[submenuIndex]}");
                                setState(() => currentSubMenuIndex = submenuIndex);
                              },
                            ),
                          );
                        } else {
                          int adjustedIndex = index;
                          if(index > 5 && isOrganizationExpanded) {
                            adjustedIndex = index - organizationSubmenu.length;
                          }
                          return ListTile(
                            leading: Icon(icons[adjustedIndex]),
                            title: Text(
                              titles[adjustedIndex],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            selected: adjustedIndex == currentIndex && !isOrganizationExpanded,
                            selectedTileColor: AppColors.primary,
                            titleTextStyle: Theme.of(context).textTheme.titleSmall,
                            onTap: () {
                              setState(() {
                                if(index != 5 )isOrganizationExpanded = false;
                                currentIndex = adjustedIndex;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: Container(
                child: isOrganizationExpanded ? orgScreens[currentSubMenuIndex]: screens[currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempScreen extends StatelessWidget {
  final String title;
  const TempScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$title Screen',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}