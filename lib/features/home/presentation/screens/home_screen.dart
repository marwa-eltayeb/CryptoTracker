import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:crypto_tracker/core/widgets/error_state.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_state.dart';
import 'package:crypto_tracker/features/home/presentation/cubit/home_cubit.dart';
import 'package:crypto_tracker/features/home/presentation/cubit/home_state.dart';
import 'package:crypto_tracker/features/home/presentation/widgets/home_header.dart';
import 'package:crypto_tracker/features/home/presentation/widgets/balance_card.dart';
import 'package:crypto_tracker/features/home/presentation/widgets/market_overview_section.dart';
import 'package:crypto_tracker/features/home/presentation/widgets/trending_coins_section.dart';
import 'package:crypto_tracker/features/home/presentation/widgets/top_gainers_section.dart';

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
                    color: AppColors.primary,
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
                // Get username from AuthCubit
                final authState = context.watch<AuthCubit>().state;
                final userName = authState is AuthAuthenticated ? (authState.user.username?.isNotEmpty == true ? authState.user.username! : 'User') : 'User';
                final userPhoto = authState is AuthAuthenticated ? authState.user.photoUrl : null;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      HomeHeader(userName: userName, userPhoto: userPhoto),
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
      ),
    );
  }
}