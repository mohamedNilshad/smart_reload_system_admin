import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final bool isDark;
  final bool isCircle;

  const ShimmerLoading({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
    this.margin,
    this.isDark = false,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkContainers : Colors.grey[300]!,
      highlightColor: isDark ? AppColors.darkGrey : Colors.grey[100]!,
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkContainers : Colors.grey[300],
          borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(4)),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

class ShimmerBannerCard extends StatelessWidget {
  final EdgeInsets? padding;

  const ShimmerBannerCard({
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ShimmerLoading(
                    height: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                ShimmerLoading(
                  height: 20,
                  width: 60,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ShimmerLoading(
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerLoading(
              height: 16,
              width: 200,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerVendorCard extends StatelessWidget {
  final EdgeInsets? padding;

  const ShimmerVendorCard({
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(
              height: 18,
              width: 150,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLoading(
                  height: 16,
                  width: 120,
                  borderRadius: BorderRadius.circular(4),
                ),
                ShimmerLoading(
                  height: 24,
                  width: 100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerClientCard extends StatelessWidget {
  final EdgeInsets? padding;

  const ShimmerClientCard({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.darkContainers,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                ShimmerLoading(
                  height: 50,
                  width: 50,
                  isCircle: true,
                  isDark: true,
                  borderRadius: BorderRadius.circular(4),
                ),
                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      height: 15,
                      width: 100,
                      isDark: true,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    ShimmerLoading(
                      height: 10,
                      width: 130,
                      isDark: true,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                Spacer(),
                ShimmerLoading(
                  height: 30,
                  width: 30,
                  isCircle: true,
                  isDark: true,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            Divider(thickness: 0.3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLoading(
                  height: 18,
                  width: 80,
                  isDark: true,
                  borderRadius: BorderRadius.circular(14),
                ),
                ShimmerLoading(
                  height: 18,
                  width: 80,
                  isDark: true,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
