import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/trending_model.dart';
import 'trending_coin_item.dart';

class TrendingCoinsSection extends StatelessWidget {
  final List<TrendingModel> trendingData;

  const TrendingCoinsSection({super.key, required this.trendingData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                AppStrings.trendingNow,
                style: AppTextStyles.bold32.copyWith(
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),

            ],
          ),
        ),

        const SizedBox(height: 16),

        // Trending Coins List
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: trendingData.length,
            itemBuilder: (context, index) {
              final coin = trendingData[index];
              return TrendingCoinItem(
                name: coin.name,
                symbol: coin.symbol,
                price: '\$${coin.price.toStringAsFixed(2)}',
                change: '${coin.priceChange.toStringAsFixed(2)}%',
                isPositive: coin.isPositive,
                icon: coin.imageUrl,
                iconColor: AppColors.orange,
              );
            },
          ),
        ),

      ],
    );
  }
}
