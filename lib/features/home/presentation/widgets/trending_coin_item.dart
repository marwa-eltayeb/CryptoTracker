import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class TrendingCoinItem extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String change;
  final bool isPositive;
  final String icon;
  final Color iconColor;

  const TrendingCoinItem({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header: Name, Symbol + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Name + Symbol
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    name,
                    style: AppTextStyles.semiBold16.copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  Text(
                    symbol,
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.greyMedium,
                    ),
                  ),

                ],
              ),

              SizedBox(width: 8),

              // Coin Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: icon,
                    width: 16,
                    height: 16,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price + Change
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTextStyles.semiBold18.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),

              // Change + Arrow
              Row(
                children: [
                  Text(
                    change,
                    style: AppTextStyles.regular14.copyWith(
                      color: isPositive ? AppColors.green : AppColors.red,
                    ),
                  ),

                  const SizedBox(width: 1),

                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? AppColors.green : AppColors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ],

      ),
    );
  }
}
