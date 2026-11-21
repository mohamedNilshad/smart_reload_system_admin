import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.ssm),
          child: Center(
            child: Column(
              children: [
                HeadlineText(text: "Manage the system", color: AppColors.white),
                SizedBox(height: Sizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, RouteConstants.newsBannerScreen),
                      hoverColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusXl),

                      child: CCard(
                        isDark: true,
                        child: Column(
                          children: [
                            Icon(Icons.newspaper, color: AppColors.white),
                            SizedBox(height: Sizes.md),
                            SubHeadlineText(text: "News Banner", color: AppColors.white),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, RouteConstants.commissionScreen),
                      hoverColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusXl),
                      child: CCard(
                        isDark: true,
                        child: Column(
                          children: [
                            Icon(Icons.percent_rounded, color: AppColors.white),
                            SizedBox(height: Sizes.md),
                            SubHeadlineText(text: "Commission", color: AppColors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
