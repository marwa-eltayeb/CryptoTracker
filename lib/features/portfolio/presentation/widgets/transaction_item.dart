import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = transaction.type == TransactionType.buy;

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
              color: isBuy
                  ? AppColors.green.withOpacity(0.1)
                  : AppColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBuy ? Icons.arrow_downward : Icons.arrow_upward,
              color: isBuy ? AppColors.green : AppColors.red,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isBuy ? AppStrings.buy : AppStrings.sell} ${transaction.coinName}',
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.balanceGradientStart,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.timeAgo,
                  style: AppTextStyles.medium13.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Amount and Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount} ${transaction.symbol}',
                style: AppTextStyles.semiBold15.copyWith(
                  color: AppColors.balanceGradientStart,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isBuy ? '-' : '+'}\$${transaction.valueUSD.toStringAsFixed(2)}',
                style: AppTextStyles.semiBold13.copyWith(
                  color: isBuy ? AppColors.red : AppColors.green,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}