import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class CoinItem extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final int rank;
  final String price;
  final double priceChange;
  final VoidCallback? onTap;

  const CoinItem({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.rank,
    required this.price,
    required this.priceChange,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = priceChange >= 0;
    final hasValidPrice = price != '--' && price != AppStrings.notAvailable && price.isNotEmpty;
    final hasPriceChange = priceChange != 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyMedium.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [

            // Coin Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 48,
                  height: 48,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) => Text(
                    symbol.isNotEmpty ? symbol[0].toUpperCase() : '?',
                    style: AppTextStyles.bold32.copyWith(
                      fontSize: 24,
                      color: AppColors.balanceGradientStart,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Coin Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.semiBold18.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.rankLabel}$rank',
                    style: AppTextStyles.regular14.copyWith(color: AppColors.greyMedium),
                  ),
                ],
              ),
            ),

            // Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: AppTextStyles.semiBold18.copyWith(
                    color: hasValidPrice ? AppColors.black : AppColors.greyMedium,
                  ),
                ),

                const SizedBox(height: 4),

                if (hasValidPrice && hasPriceChange)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? AppColors.green.withOpacity(0.2)
                          : AppColors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 14,
                          color: isPositive ? AppColors.green : AppColors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${priceChange.abs().toStringAsFixed(1)}%',
                          style: AppTextStyles.semiBold16.copyWith(
                            color: isPositive ? AppColors.green : AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (!hasValidPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove,
                          size: 14,
                          color: AppColors.greyMedium,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.notAvailable,
                          style: AppTextStyles.semiBold16.copyWith(color: AppColors.greyMedium),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
