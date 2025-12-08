import 'package:flutter/material.dart';
import '../../config/routing/routes.dart';
import '../../config/theme/app_colors.dart';
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
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.home);
              },
            ),
            NavBarItem(
              icon: Icons.bar_chart,
              label: 'Market',
              isSelected: currentIndex == 1,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.market);
              },
            ),
            NavBarItem(
              icon: Icons.business_center,
              label: 'Portfolio',
              isSelected: currentIndex == 2,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.portfolio);
              },
            ),
            NavBarItem(
              icon: Icons.settings,
              label: 'Settings',
              isSelected: currentIndex == 3,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}

