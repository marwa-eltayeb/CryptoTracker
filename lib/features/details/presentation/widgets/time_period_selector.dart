import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class TimePeriodSelector extends StatelessWidget {
  final Function(String) onPeriodChanged;
  final String selectedPeriod;

  const TimePeriodSelector({
    super.key,
    required this.onPeriodChanged,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> periods = ['1d', '1w', '1m', '1y'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: periods.map((period) {
          final isSelected = period == selectedPeriod;
          return GestureDetector(
            onTap: () {
              onPeriodChanged(period);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.balanceGradientStart : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: (isSelected ? AppTextStyles.semiBold14 : AppTextStyles.medium14).copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}