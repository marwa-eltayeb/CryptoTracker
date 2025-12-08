import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class CoinItem extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String change;
  final bool isPositive;
  final String icon;
  final Color iconBgColor;

  const CoinItem({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: icon,
                width: 24,
                height: 24,
                placeholder: (context, url) =>
                const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: AppTextStyles.semiBold18.copyWith(
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
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                price,
                style: AppTextStyles.semiBold18.copyWith(
                  color: AppColors.black,
                ),
              ),

              Text(
                change,
                style: AppTextStyles.regular14.copyWith(
                  color:
                  isPositive ? AppColors.green : AppColors.red,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
