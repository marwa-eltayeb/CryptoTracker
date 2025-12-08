import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class MarketStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? change;
  final bool? isPositive;

  const MarketStatCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: AppTextStyles.semiBold16.copyWith(
              fontSize: 14,
              color: AppColors.greyMedium,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: AppTextStyles.bold32.copyWith(
              fontSize: 24,
              color: AppColors.black,
            ),
          ),

          if (change != null && isPositive != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [

                Text(
                  change!,
                  style: AppTextStyles.regular14.copyWith(
                    color: isPositive! ? AppColors.green : AppColors.red,
                  ),
                ),

                const SizedBox(width: 4),

                Icon(
                  isPositive! ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositive! ? AppColors.green : AppColors.red,
                ),

              ],
            ),
          ],
        ],
      ),
    );
  }
}
