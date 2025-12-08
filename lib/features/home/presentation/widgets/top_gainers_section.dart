import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/coin_market_model.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import 'coin_item.dart';

class TopGainersSection extends StatelessWidget {
  final List<CoinMarketModel> topGainers;

  const TopGainersSection({super.key, required this.topGainers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Title
          Text(
            AppStrings.topGainers,
            style: AppTextStyles.bold32.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Coin Lists
          ...topGainers.map(
                (coin) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CoinItem(
                name: coin.name,
                symbol: coin.symbol,
                price: '\$${coin.price.toStringAsFixed(2)}',
                change: '${coin.priceChange.toStringAsFixed(2)}%',
                isPositive: coin.isPositive,
                icon: coin.imageUrl,
                iconBgColor: AppColors.orange,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
