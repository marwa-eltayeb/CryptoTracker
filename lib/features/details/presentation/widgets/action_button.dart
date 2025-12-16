import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.balanceGradientStart : AppColors.secondaryButtonBg,
          foregroundColor: isPrimary ? AppColors.white : AppColors.secondaryButtonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
        ),
        child: Text(label, style: AppTextStyles.semiBold18.copyWith(color: isPrimary ? AppColors.white : AppColors.secondaryButtonText)),
      ),
    );
  }
}