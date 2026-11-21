
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/body_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/label_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/empty_screen.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/fallback.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/shimmer_loading.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.event.dart';
import 'package:smart_reload_system_admin/src/feature/notification/presentation/bloc/notification.state.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String uid = "";
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState is SessionAuthenticated) {
      uid = sessionState.user.uid;
      context.read<NotificationBloc>().add(NotificationListRequested(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = HelperFunctions.screenWidth(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationBloc>().add(NotificationListRequested(uid));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldVendor,

        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {

            if (state is NotificationLoading || state is NotificationInitial) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    ShimmerLoading(
                      isDark: true,
                      height: 80,
                      width: screenWidth,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    ShimmerLoading(
                      isDark: true,
                      height: 80,
                      width: screenWidth,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    ShimmerLoading(
                      isDark: true,
                      height: 80,
                      width: screenWidth,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationFailureState) {
              return FallbackWidget(
                isDark: true,
                  message: "No notifications found",
                  onPressed: () {
                    context.read<NotificationBloc>().add(NotificationListRequested(uid));
                  }
              );
            }

            final notifications = (state as NotificationLoaded).notifications;
            if (notifications.isEmpty) {
              return EmptyScreenWidget(isDark: true, message: "No notification found");
            }
            
            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              padding: EdgeInsets.only(top: Sizes.sm),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  tileColor: (item.isRead ? AppColors.darkerGrey : AppColors.grey.withValues(alpha: 0.4)),
                  title: TitleText(
                    text: item.title,
                    isBold: !item.isRead,
                    color: AppColors.grey,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                        text: item.body,
                        size: 13,
                        maxLines: 2,
                        color: AppColors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      LabelText(
                        text: HelperFunctions.formatRelativeDate(item.createdAt),
                        color: AppColors.info,
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.done_all_rounded,
                    color: (item.isRead ? AppColors.info : AppColors.softGrey),
                  ),
                  onTap: () {
                    if(!item.isRead){
                      context.read<NotificationBloc>().add(
                        NotificationMarkAsReadRequested(uid: uid, notificationId: item.id),
                      );
                    }
                    if (item.route != null && item.route!.isNotEmpty) Navigator.of(context).pushNamed(item.route!);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
