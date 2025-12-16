import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class PriceChangeBadge extends StatelessWidget {

  final double changePercentage;

  const PriceChangeBadge({super.key, required this.changePercentage});

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercentage >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.balanceGradientStart, borderRadius: BorderRadius.circular(8),),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: AppColors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${changePercentage.abs().toStringAsFixed(1)}%',
            style: AppTextStyles.semiBold14.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
