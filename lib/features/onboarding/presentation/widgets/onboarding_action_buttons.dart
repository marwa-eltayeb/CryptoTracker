import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class OnboardingActionButtons extends StatelessWidget {
  const OnboardingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.login,
              style: AppTextStyles.semiBold18,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Register Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to register
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              AppStrings.register,
              style: AppTextStyles.semiBold18,
            ),
          ),
        ),

      ],
    );
  }
}