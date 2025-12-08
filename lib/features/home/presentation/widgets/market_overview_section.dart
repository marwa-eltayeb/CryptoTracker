import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/global_market_model.dart';
import 'market_stat_card.dart';

class MarketOverviewSection extends StatelessWidget {
  final GlobalMarketModel marketData;

  const MarketOverviewSection({super.key, required this.marketData});

  bool _isPositive(String value) => !value.trim().startsWith('-');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Title
          Text(
            AppStrings.marketOverview,
            style: AppTextStyles.bold32.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          //  Market Cap + 24h Volume
          Row(
            children: [

              Expanded(
                child: MarketStatCard(
                  title: AppStrings.marketCap,
                  value: marketData.marketCap,
                  change: marketData.marketCapChange,
                  isPositive: _isPositive(marketData.marketCapChange),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: MarketStatCard(
                  title: AppStrings.volume24h,
                  value: marketData.volume24h,
                  change: marketData.volumeChange,
                  isPositive: _isPositive(marketData.volumeChange),
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          // BTC Dominance + Active Coins
          Row(
            children: [

              Expanded(
                child: MarketStatCard(
                  title: AppStrings.btcDominance,
                  value: marketData.btcDominance,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: MarketStatCard(
                  title: AppStrings.activeCoins,
                  value: '${marketData.activeCoins}',
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
