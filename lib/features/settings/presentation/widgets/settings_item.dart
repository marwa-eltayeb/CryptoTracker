import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? AppColors.balanceGradientStart,
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: iconColor ?? AppColors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.medium18.copyWith(
                  color: AppColors.balanceGradientStart,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.balanceGradientStart,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}