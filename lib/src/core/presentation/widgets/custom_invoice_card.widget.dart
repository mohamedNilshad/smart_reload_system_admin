import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/body_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';

class CustomInvoiceCard extends StatelessWidget {
  final Function()? onTap;
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;

  const CustomInvoiceCard({
    super.key,
    this.onTap,
    this.isDark = false,
    this.icon = Icons.question_mark_rounded,
    required this.title,
    required this.subtitle,
    this.amount = 0.0,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.ssm),
        margin: EdgeInsetsGeometry.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkContainers : AppColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.green.withValues(alpha: 0.2),
              child: Icon(icon, color: AppColors.green, size: 35,),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                TitleText(text: title, color: isDark ? AppColors.white : AppColors.darkerGrey),
                BodyText(text: subtitle, size: 10, color: isDark ? AppColors.lightGrey : AppColors.darkGrey),
              ],
            ),

            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubHeadlineText(text: HelperFunctions.formatCurrency(amount), color: isDark ? AppColors.white : AppColors.darkerGrey, size: 16.0,),
                BodyText(text: HelperFunctions.formatDateTime(date, withTime: false), size: 10, color: isDark ? AppColors.lightGrey : AppColors.darkGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
