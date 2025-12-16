import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../data/models/holding.dart';

class HoldingItem extends StatelessWidget {
  final Holding holding;

  const HoldingItem({
    super.key,
    required this.holding,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.changeAmount >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black04Shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getIconText(),
                style: AppTextStyles.bold24.copyWith(
                  color: _getIconColor(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and Symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.name,
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.balanceGradientStart,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  holding.symbol,
                  style: AppTextStyles.medium13.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${holding.amount} ${holding.symbol}',
                  style: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.balanceGradientStart,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '\$${holding.valueUSD.toStringAsFixed(2)}',
                  style: AppTextStyles.semiBold13.copyWith(
                    color: AppColors.chartTooltip,
                  ),
                ),
              ],
            ),
          ),
          // Percentage and Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                '${holding.percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.bold20.copyWith(
                  color: AppColors.balanceGradientStart,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${isPositive ? '+' : ''}\$${holding.changeAmount.toStringAsFixed(2)}',
                style: AppTextStyles.semiBold14.copyWith(
                  color: isPositive ? AppColors.green : AppColors.red,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '${isPositive ? '+' : ''}${holding.changePercentage.toStringAsFixed(2)}%',
                style: AppTextStyles.semiBold13.copyWith(
                  color: isPositive ? AppColors.green : AppColors.red,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  // These methods return dynamic data based on user's holdings
  Color _getIconColor() {
    switch (holding.symbol) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'LTC':
        return const Color(0xFF345D9D);
      default:
        return Colors.grey;
    }
  }

  String _getIconText() {
    switch (holding.symbol) {
      case 'BTC':
        return '₿';
      case 'ETH':
        return 'Ξ';
      case 'LTC':
        return 'Ł';
      default:
        return '?';
    }
  }
}