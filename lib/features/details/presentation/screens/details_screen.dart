import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/error_state.dart';
import '../cubit/details_cubit.dart';
import '../cubit/details_states.dart';
import '../widgets/coin_header.dart';
import '../widgets/price_change_badge.dart';
import '../widgets/price_chart.dart';
import '../widgets/time_period_selector.dart';
import '../widgets/stat_item.dart';
import '../widgets/action_button.dart';

class DetailsScreen extends StatelessWidget {
  final String coinId;

  const DetailsScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailsCubit>()..loadCoinDetails(coinId),
      child: Builder(
        builder: (context) {
          final cubit = context.read<DetailsCubit>();

          return Scaffold(
            backgroundColor: AppColors.backgroundGrey,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.balanceGradientStart),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                AppStrings.coinDetails,
                style: AppTextStyles.bold20.copyWith(color: AppColors.balanceGradientStart),
              ),
            ),
            body: BlocBuilder<DetailsCubit, DetailsState>(
              builder: (context, state) {
                // Handle initial coin details loading
                if (state is CoinDetailsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.balanceGradientStart),
                  );
                }

                // Handle coin details error
                if (state is CoinDetailsError) {
                  return ErrorState(
                    title: AppStrings.errorLoadingCoinDetails,
                    message: state.message,
                    onRetry: () => cubit.loadCoinDetails(coinId),
                  );
                }

                // Get coin details
                final coinDetail = cubit.coinDetail;
                if (coinDetail == null) {
                  return const SizedBox.shrink();
                }

                // Get chart data and selected period
                final chartData = cubit.chartData;
                final selectedPeriod = cubit.selectedPeriod;

                // Determine chart state
                final isChartLoading = state is ChartLoading;
                final chartErrorMessage = state is ChartError ? state.errorMessage : null;

                return SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Coin Header Section
                        CoinHeader(
                          thumb: coinDetail.image,
                          name: coinDetail.name,
                        ),

                        // Price Chart Section
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Price Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${coinDetail.currentPrice.toStringAsFixed(2)}',
                                        style: AppTextStyles.bold32.copyWith(
                                          color: AppColors.balanceGradientStart,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '/ 1 ${coinDetail.symbol.toUpperCase()}',
                                        style: AppTextStyles.regular14.copyWith(
                                          color: AppColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PriceChangeBadge(
                                    changePercentage: coinDetail.priceChange24h,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Prices Chart
                              SizedBox(
                                height: 250,
                                child: Stack(
                                  children: [
                                    // Chart
                                    if (chartData.isNotEmpty)
                                      RepaintBoundary(
                                        child: PriceChart(
                                          data: chartData,
                                          currentPrice: coinDetail.currentPrice,
                                          selectedPeriod: selectedPeriod,
                                        ),
                                      )
                                    else
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundGrey,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppStrings.noChartDataAvailable,
                                            style: AppTextStyles.regular14.copyWith(
                                              color: AppColors.greyText,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Loading Overlay
                                    if (isChartLoading)
                                      IgnorePointer(
                                        child: Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: AppColors.balanceGradientStart,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Error Overlay
                                    if (chartErrorMessage != null)
                                      IgnorePointer(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppStrings.failedToLoadChart,
                                              style: AppTextStyles.regular14.copyWith(
                                                color: AppColors.greyText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Time Period Selector
                              TimePeriodSelector(
                                selectedPeriod: selectedPeriod,
                                onPeriodChanged: (period) {
                                  context.read<DetailsCubit>().updateChartPeriod(coinId, period);
                                },
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Statistics Section
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                                child: Text(
                                  AppStrings.statistics,
                                  style: AppTextStyles.bold20.copyWith(
                                    color: AppColors.balanceGradientStart,
                                  ),
                                ),
                              ),
                              StatItem(
                                label: AppStrings.currentPriceLabel,
                                value: '\$${coinDetail.currentPrice.toStringAsFixed(2)}',
                                hasInfoIcon: true,
                              ),
                              StatItem(
                                label: AppStrings.marketCapLabel,
                                value: '\$${NumberFormatter.formatLargeNumber(coinDetail.marketCap)}',
                                hasInfoIcon: true,
                              ),
                              StatItem(
                                label: AppStrings.volume24hLabel,
                                value: '\$${NumberFormatter.formatLargeNumber(coinDetail.volume24h)}',
                                hasInfoIcon: true,
                              ),
                              StatItem(
                                label: AppStrings.availableSupplyLabel,
                                value: NumberFormatter.formatLargeNumber(coinDetail.availableSupply),
                                hasInfoIcon: true,
                              ),
                              StatItem(
                                label: AppStrings.maxSupplyLabel,
                                value: coinDetail.maxSupply > 0
                                    ? NumberFormatter.formatLargeNumber(coinDetail.maxSupply)
                                    : 'Unlimited',
                                hasInfoIcon: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // About Section
                        if (coinDetail.about.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackShadow,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppStrings.about} ${coinDetail.name}',
                                  style: AppTextStyles.bold20.copyWith(
                                    color: AppColors.balanceGradientStart,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  coinDetail.about,
                                  style: AppTextStyles.regular15WithHeight.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              ActionButton(
                                label: AppStrings.sell,
                                isPrimary: false,
                                onPressed: () {
                                  SnackBarUtils.showSnackBar(context, AppStrings.sellAction);
                                },
                              ),
                              const SizedBox(width: 16),
                              ActionButton(
                                label: AppStrings.buy,
                                isPrimary: true,
                                onPressed: () {
                                  Navigator.pushNamed(context, Routes.payment);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}