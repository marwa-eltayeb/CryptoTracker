import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/error_state.dart';
import '../widgets/home_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/market_overview_section.dart';
import '../widgets/trending_coins_section.dart';
import '../widgets/top_gainers_section.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1E3A5F),
                  ),
                );
              }

              if (state is HomeError) {
                return ErrorState(
                  title: AppStrings.errorLoadingData,
                  message: state.failure.errMessage,
                  onRetry: () => context.read<HomeCubit>().loadHomeData(),
                );
              }

              if (state is HomeLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      HomeHeader(userName: 'Marwa'),
                      const SizedBox(height: 16),
                      BalanceCard(
                        balance: AppStrings.defaultBalance,
                        weeklyProfit: AppStrings.weeklyProfitLabel,
                        profitPercentage: AppStrings.defaultProfitPercentage,
                      ),
                      const SizedBox(height: 24),
                      MarketOverviewSection(marketData: state.market),
                      const SizedBox(height: 24),
                      TrendingCoinsSection(trendingData: state.trendingData),
                      const SizedBox(height: 24),
                      TopGainersSection(topGainers: state.topGainers),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}