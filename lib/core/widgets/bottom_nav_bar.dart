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

  void _navigateToScreen(BuildContext context, int index) {

    if (currentIndex == index) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = Routes.home;
        break;
      case 1:
        routeName = Routes.market;
        break;
      case 2:
        routeName = Routes.portfolio;
        break;
      case 3:
        routeName = Routes.settings;
        break;
      default:
        return;
    }

    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              onTap: () => _navigateToScreen(context, 0),
            ),
            NavBarItem(
              icon: Icons.bar_chart,
              label: AppStrings.marketScreenTitle,
              isSelected: currentIndex == 1,
              onTap: () => _navigateToScreen(context, 1),
            ),
            NavBarItem(
              icon: Icons.business_center,
              label: AppStrings.portfolioScreenTitle,
              isSelected: currentIndex == 2,
              onTap: () => _navigateToScreen(context, 2),
            ),
            NavBarItem(
              icon: Icons.settings,
              label: AppStrings.settingsScreenTitle,
              isSelected: currentIndex == 3,
              onTap: () => _navigateToScreen(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}