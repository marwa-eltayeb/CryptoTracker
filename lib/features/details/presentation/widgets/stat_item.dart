import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool hasInfoIcon;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.hasInfoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.greyBorder, width: 1),),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.medium15.copyWith(color: AppColors.balanceGradientStart,),
              ),
              if (hasInfoIcon) ...[
                const SizedBox(width: 8),
                const Icon(Icons.info, size: 16, color: AppColors.infoBlue),
              ],
            ],
          ),
          Text(
            value,
            style: AppTextStyles.semiBold15.copyWith(color: AppColors.textSecondary,),
          ),
        ],
      ),
    );
  }
}
