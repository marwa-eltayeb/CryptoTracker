import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../data/models/holding.dart';
import '../cubit/portfolio_cubit.dart';
import 'remove_holding_dialog.dart';

class HoldingItem extends StatelessWidget {
  final Holding holding;

  const HoldingItem({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.changeAmount >= 0;

    return GestureDetector(
      onLongPress: () => _showRemoveDialog(context),
      child: Container(
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
            // Coin Image
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: holding.iconPath,
                  width: 48,
                  height: 48,
                  placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
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
                    holding.symbol.toUpperCase(),
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
      ),
    );
  }

  void _showRemoveDialog(BuildContext context) {
    final portfolioCubit = context.read<PortfolioCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => RemoveHoldingDialog(
        holding: holding,
        onRemove: () {
          portfolioCubit.removeHolding(holding.coinId);
        },
      ),
    );
  }
}