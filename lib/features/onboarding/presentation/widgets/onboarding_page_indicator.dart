import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        totalPages, (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: index == currentPage ? 32 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: index == currentPage
              ? AppColors.primary
              : AppColors.indicatorInactive,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      ),
    );
  }
}