import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/error_state.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import '../widgets/empty_holdings.dart';
import '../widgets/portfolio_value_card.dart';
import '../widgets/month_selector.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/holding_item.dart';
import '../widgets/transaction_item.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PortfolioCubit>()..loadPortfolio(),
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: AppBar(
          backgroundColor: AppColors.greyBackground,
          elevation: 0,
          title: Text(
            AppStrings.portfolioScreenTitle,
            style: AppTextStyles.bold32.copyWith(
              color: AppColors.primary,
            ),
          ),
          toolbarHeight: 80,
        ),
        body: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            final cubit = context.read<PortfolioCubit>();

            if (state is PortfolioLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PortfolioError) {
              return ErrorState(
                title: AppStrings.errorLoadingPortfolio,
                message: state.message,
                onRetry: () => cubit.loadPortfolio(),
              );
            }

            if (state is PortfolioLoaded) {
              final hasHoldings = state.holdings.isNotEmpty;

              return RefreshIndicator(
                onRefresh: () => cubit.loadPortfolio(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        PortfolioValueCard(
                          totalValue: state.totalValue,
                          changeAmount: state.totalChangeAmount,
                          changePercentage: state.totalChangePercentage,
                        ),

                        const SizedBox(height: 24),

                        const MonthSelector(),

                        const SizedBox(height: 24),

                        PortfolioPieChart(
                          totalValue: state.totalValue,
                          holdings: state.holdings,
                        ),

                        const SizedBox(height: 32),

                        Text(
                          AppStrings.myHoldings,
                          style: AppTextStyles.semiBold22.copyWith(
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (hasHoldings)
                          ...state.holdings.map((holding) => HoldingItem(holding: holding))
                        else
                          EmptyHoldings(),

                        const SizedBox(height: 32),

                        Text(
                          AppStrings.recentTransactions,
                          style: AppTextStyles.semiBold22.copyWith(
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ...state.transactions.map((transaction) => TransactionItem(transaction: transaction)),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      ),
    );
  }
}