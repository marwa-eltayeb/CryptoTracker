import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String weeklyProfit;
  final String profitPercentage;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.weeklyProfit,
    required this.profitPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.balanceGradientStart,
            AppColors.balanceGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          Text(
            AppStrings.currentBalance,
            style: AppTextStyles.semiBold16.copyWith(
              color: AppColors.white70,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '\$$balance',
            style: AppTextStyles.bold32.copyWith(
              color: AppColors.white,
              fontSize: 40,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weeklyProfit,
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.white70,
                ),
              ),
              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white20,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [

                    Text(
                      profitPercentage,
                      style: AppTextStyles.semiBold16.copyWith(
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.arrow_upward,
                      color: AppColors.white,
                      size: 16,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
