import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/error_state.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_states.dart';
import '../widgets/category_chip.dart';
import '../widgets/coin_item.dart';
import '../widgets/custom_search.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {

  int _selectedCategoryIndex = 0;

  late final List<String> _categories = [
    AppStrings.categoryAll,
    AppStrings.categoryDeFi,
    AppStrings.categoryNFT,
    AppStrings.categoryGaming,
    AppStrings.categoryMetaverse
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketCubit>()..loadCoinList(),
      child: Builder(builder: (context) {
        final cubit = context.read<MarketCubit>();

        return Scaffold(
          backgroundColor: AppColors.grey100,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Text(
                    AppStrings.cryptoMarket,
                    style: AppTextStyles.bold32.copyWith(color: AppColors.primary),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomSearch(
                    controller: _searchController,
                    hintText: AppStrings.searchCoinsHint,
                    onChanged: (value) => cubit.searchCoins(value),
                    onFilterTap: () => SnackbarUtils.showSnackbar(context, AppStrings.filterTapped),
                  ),
                ),

                const SizedBox(height: 20),

                // Categories
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CategoryChip(
                          label: _categories[index],
                          isSelected: _selectedCategoryIndex == index,
                          onTap: () {
                            setState(() {
                              SnackbarUtils.showSnackbar(context, _categories[index]);
                              _selectedCategoryIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Coin List
                Expanded(
                  child: BlocBuilder<MarketCubit, MarketState>(
                    builder: (context, state) {
                      if (state is CoinListLoading || state is SearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state is CoinListError) {
                        return ErrorState(
                          title: AppStrings.errorLoadingCoins,
                          message: state.failure.errMessage,
                          onRetry: () => cubit.loadCoinList(),
                        );
                      }

                      if (state is SearchError) {
                        return ErrorState(
                          title: AppStrings.searchError,
                          message: state.failure.errMessage,
                          onRetry: () => cubit.loadCoinList(),
                        );
                      }

                      if (state is SearchEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: AppColors.greyMedium),
                              const SizedBox(height: 16),
                              Text(
                                AppStrings.noResultsFound,
                                style: AppTextStyles.semiBold18.copyWith(color: AppColors.greyMedium),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.tryDifferentCoin,
                                style: AppTextStyles.regular14.copyWith(color: AppColors.greyMedium),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is SearchLoaded) {
                        final results = cubit.searchResults;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final coin = results[index];
                            return CoinItem(
                              name: coin.name,
                              symbol: coin.symbol,
                              imageUrl: coin.thumb ?? '',
                              rank: coin.marketCapRank,
                              price: '--',
                              priceChange: 0,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.details, arguments: coin.id,);
                              },
                            );
                          },
                        );
                      }

                      if (state is CoinListLoaded) {
                        final coins = cubit.allCoins;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: coins.length,
                          itemBuilder: (context, index) {
                            final coin = coins[index];
                            return CoinItem(
                              name: coin.name,
                              symbol: coin.symbol,
                              imageUrl: coin.image,
                              rank: coin.marketCapRank,
                              price: '\$${coin.currentPrice.toStringAsFixed(2)}',
                              priceChange: coin.priceChangePercentage24h,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.details, arguments: coin.id,);
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 1),
        );
      }),
    );
  }
}
