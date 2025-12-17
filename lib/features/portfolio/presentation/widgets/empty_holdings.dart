import 'package:flutter/material.dart';
import '../../../../config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class EmptyHoldings extends StatelessWidget {
  const EmptyHoldings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            AppStrings.noHoldingsYet,
            style: AppTextStyles.semiBold18.copyWith(
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            AppStrings.startBuildingPortfolio,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.greyMedium,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              // Navigate to market screen
              Navigator.pushReplacementNamed(context, Routes.market);
            },
            icon: const Icon(Icons.add, color: AppColors.white),
            label: Text(
              AppStrings.browseMarket,
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

        ],
      ),
    );
  }
}