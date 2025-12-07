import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    // Check if this is the welcome page by comparing with the combined string
    final hasColoredText = title == AppStrings.welcomeToCryptoX;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          hasColoredText ? RichText(
            text: TextSpan(
              style: AppTextStyles.bold32.copyWith(
                color: AppColors.black,
              ),
              children: const [
                TextSpan(text: AppStrings.welcomeTo),
                TextSpan(
                  text: AppStrings.cryptoX,
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ) : Text(
            title,
            style: AppTextStyles.bold32.copyWith(
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}