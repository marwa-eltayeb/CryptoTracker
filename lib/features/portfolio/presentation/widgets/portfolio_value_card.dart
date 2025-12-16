import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class PortfolioValueCard extends StatelessWidget {
  final double totalValue;
  final double changeAmount;
  final double changePercentage;

  const PortfolioValueCard({
    super.key,
    required this.totalValue,
    required this.changeAmount,
    required this.changePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changeAmount >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.portfolioGradientStart, AppColors.portfolioGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.portfolioGradientStart.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            AppStrings.totalValue,
            style: AppTextStyles.semiBold16.copyWith(
              color: AppColors.white80,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '\$${totalValue.toStringAsFixed(2)}',
            style: AppTextStyles.bold36.copyWith(
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(1)}% (\$${changeAmount.toStringAsFixed(2)}) ${AppStrings.today}',
            style: AppTextStyles.medium14.copyWith(
              color: isPositive ? AppColors.green : AppColors.red,
            ),
          ),

        ],
      ),
    );
  }
}