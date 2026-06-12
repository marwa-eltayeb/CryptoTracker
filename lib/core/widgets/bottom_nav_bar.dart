import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              icon: Icons.home,
              label: AppStrings.homeScreenTitle,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavBarItem(
              icon: Icons.bar_chart,
              label: AppStrings.marketScreenTitle,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            NavBarItem(
              icon: Icons.business_center,
              label: AppStrings.portfolioScreenTitle,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            NavBarItem(
              icon: Icons.settings,
              label: AppStrings.settingsScreenTitle,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}