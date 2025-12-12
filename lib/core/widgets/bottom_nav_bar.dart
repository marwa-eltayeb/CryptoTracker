// bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../../config/routing/routes.dart';
import '../../config/theme/app_colors.dart';
import '../constants/app_strings.dart';
import 'nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
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
              onTap: () {
                if (currentIndex != 0) {
                  Navigator.pushReplacementNamed(context, Routes.home);
                }
              },
            ),
            NavBarItem(
              icon: Icons.bar_chart,
              label: AppStrings.marketScreenTitle,
              isSelected: currentIndex == 1,
              onTap: () {
                if (currentIndex != 1) {
                  Navigator.pushReplacementNamed(context, Routes.market);
                }
              },
            ),
            NavBarItem(
              icon: Icons.business_center,
              label: AppStrings.portfolioScreenTitle,
              isSelected: currentIndex == 2,
              onTap: () {
                if (currentIndex != 2) {
                  Navigator.pushReplacementNamed(context, Routes.portfolio);
                }
              },
            ),
            NavBarItem(
              icon: Icons.settings,
              label: AppStrings.settingsScreenTitle,
              isSelected: currentIndex == 3,
              onTap: () {
                if (currentIndex != 3) {
                  Navigator.pushReplacementNamed(context, Routes.settings);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}