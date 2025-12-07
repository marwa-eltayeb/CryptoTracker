import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingNavigationButton extends StatelessWidget {

  final VoidCallback onPressed;

  const OnboardingNavigationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
        ),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.white,
          size: 24,
        ),
      ),
    );
  }
}