import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';

enum FaceIdCardState { idle, scanning, complete }

class FaceIdCard extends StatelessWidget {
  final FaceIdCardState cardState;
  final VoidCallback? onTap;

  const FaceIdCard({
    super.key,
    required this.cardState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show checkmark for complete state, Face ID icon otherwise
            if (cardState == FaceIdCardState.complete)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 32,
                ),
              )
            else
              SvgPicture.asset(
                AppAssets.faceIdIcon,
                width: 50,
                height: 50,
                colorFilter: ColorFilter.mode(
                  cardState == FaceIdCardState.scanning
                      ? AppColors.primary
                      : AppColors.greyMedium,
                  BlendMode.srcIn,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              AppStrings.faceID,
              style: AppTextStyles.semiBold16.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}