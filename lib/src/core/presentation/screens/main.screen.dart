import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, WindowListener {
  int currentIndex = 0;
  int currentSubMenuIndex = 0;
  bool isManageExpanded = false;

  List<Widget> screens = [
    const TempScreen(title: "Dashboard"), //report
    const TempScreen(title: "Manage"), //manage(Service providers, packages, commission percentage, vendors and clients.)
    const TempScreen(title: "Wallet"), //wallet
    const TempScreen(title: "System"), //system
    const TempScreen(title: "Notification"), //notification
    const TempScreen(title: "Profile"), //profile
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

  final List<String> manageSubmenu = [
    "Service providers",
    "Packages",
    "Commission",
    "Users",
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    bool isLogoutLoading = false;
    if (isPreventClose && mounted) {
      bool shouldClose =
          await showDialog(
            context: context,
            builder: (context) {
              return BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    if (mounted) setState(() => isLogoutLoading = state.isLogout);
                  }

                  if(state is AuthLogoutSuccess) {
                    if (mounted) setState(() => isLogoutLoading = false);
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteConstants.loginScreen, (route) => false);
                  }

                  if(state is AuthFailureState) {
                    if (mounted) setState(() => isLogoutLoading = false);
                    AppSnackbar.showError(context, state.message);
                  }
                },
                child: AlertDialog(
                  title: const Text("Confirm Exit"),
                  content: const Text("Are you sure you want to Logout ?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CElevatedButton(
                      isLoading: isLogoutLoading,
                      width: 100,
                      label:"Logout",
                      onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
                    ),
                  ],
                ),
              );
            },
          ) ??
          false;

      if (shouldClose) {
        await windowManager.destroy();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _showLogoutDialog() async {
    bool isLogoutLoading = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              if (mounted) setState(() => isLogoutLoading = state.isLogout);
            }

            if (state is AuthLogoutSuccess) {
              if (mounted) setState(() => isLogoutLoading = false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteConstants.loginScreen,
                (route) => false,
              );
            }

            if (state is AuthFailureState) {
              if (mounted) setState(() => isLogoutLoading = false);
              AppSnackbar.showError(context, state.message);
            }
          },
          child: AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("Cancel"),
              ),
              CElevatedButton(
                isLoading: isLogoutLoading,
                width: 100,
                label: "Logout",
                onPressed: () =>
                    dialogContext.read<AuthBloc>().add(LogoutRequested()),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    double screenWidth = HelperFunctions.screenWidth(context);
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: (screenWidth * 0.18).clamp(180.0, 280.0),
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
                    itemCount: titles.length + (isManageExpanded ? manageSubmenu.length : 0),
                    itemBuilder: (context, index) {
                      if (index == 1) {
                        return ListTile(
                          leading: Icon(icons[index]),
                          title: Text(
                            titles[index],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          selected: isManageExpanded || index == currentIndex,
                          selectedTileColor: AppColors.primary,
                          titleTextStyle: Theme.of(context).textTheme.titleSmall,
                          onTap: () {
                            setState(() {
                              isManageExpanded = !isManageExpanded;
                              if (isManageExpanded) currentIndex = index;
                            });
                          },
                          trailing: Icon(
                            isManageExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right_rounded,
                          ),
                        );
                      } else if (index > 1 && index < 2 + manageSubmenu.length && isManageExpanded) {
                        final submenuIndex = index - 2;
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ListTile(
                            title: Text(
                              manageSubmenu[submenuIndex],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            titleTextStyle: Theme.of(context).textTheme.bodySmall,
                            selected: submenuIndex == currentSubMenuIndex,
                            selectedTileColor: AppColors.purple,
                            onTap: () {
                              debugPrint("Tapped on ${manageSubmenu[submenuIndex]}");
                              setState(() {
                                currentSubMenuIndex = submenuIndex;
                                currentIndex = 1;
                              });
                            },
                          ),
                        );
                      } else {
                        int adjustedIndex = index;
                        if (index > 1 && isManageExpanded) {
                          adjustedIndex = index - manageSubmenu.length;
                        }
                        return ListTile(
                          leading: Icon(icons[adjustedIndex]),
                          title: Text(
                            titles[adjustedIndex],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          selected:
                              adjustedIndex == currentIndex &&
                              !isManageExpanded,
                          selectedTileColor: AppColors.primary,
                          titleTextStyle: Theme.of(
                            context,
                          ).textTheme.titleSmall,
                          onTap: () {
                            setState(() {
                              isManageExpanded = false;
                              currentIndex = adjustedIndex;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text("Logout"),
                    titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.red,
                    ),
                    onTap: _showLogoutDialog,
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: Container(
              child: isManageExpanded
                  ? orgScreens[currentSubMenuIndex]
                  : screens[currentIndex],
            ),
          ),
        ],
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
