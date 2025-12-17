import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/portfolio_storage.dart';
import '../../data/models/holding.dart';
import '../../data/models/transaction.dart';
import '../../data/repository/portfolio_repository.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final PortfolioRepository repository;

  PortfolioCubit({required this.repository}) : super(PortfolioInitial());

  Future<void> loadPortfolio() async {
    emit(PortfolioLoading());

    try {
      final userHoldingsData = await repository.getUserHoldings();
      final transactions = _getMockTransactions();

      if (userHoldingsData.isEmpty) {
        emit(PortfolioLoaded(
          holdings: [],
          transactions: transactions,
          totalValue: 0.0,
          totalChangeAmount: 0.0,
          totalChangePercentage: 0.0,
        ));
        return;
      }

      final coinIds = userHoldingsData.map((h) => h.coinId).toList();
      final result = await repository.getPortfolioPrices(coinIds);

      result.fold(
            (failure) => emit(PortfolioError(message: failure.errMessage)),
            (priceData) {
          final holdings = _calculateHoldings(priceData.prices, userHoldingsData);

          final totalValue = holdings.fold<double>(0.0, (sum, holding) => sum + holding.valueUSD,);

          final totalChangeAmount = holdings.fold<double>(0.0, (sum, holding) => sum + holding.changeAmount,);

          final totalChangePercentage = totalValue > 0 ? (totalChangeAmount / (totalValue - totalChangeAmount)) * 100 : 0.0;

          emit(PortfolioLoaded(
            holdings: holdings,
            transactions: transactions,
            totalValue: totalValue,
            totalChangeAmount: totalChangeAmount,
            totalChangePercentage: totalChangePercentage,
          ));
        },
      );
    } catch (e) {
      emit(PortfolioError(message: e.toString()));
    }
  }

  Future<void> addHolding(String coinId, String name, String symbol, double amount, String imageUrl) async {
    await repository.addHolding(coinId, name, symbol, amount, imageUrl);
    await loadPortfolio();
  }

  Future<void> updateHolding(String coinId, double amount) async {
    await repository.updateHolding(coinId, amount);
    await loadPortfolio();
  }

  Future<void> removeHolding(String coinId) async {
    await repository.removeHolding(coinId);
    await loadPortfolio();
  }

  List<Holding> _calculateHoldings(
      Map<String, dynamic> prices,
      List<CoinHoldingData> userHoldingsData,
      ) {
    final List<Holding> holdings = [];
    double totalValue = 0.0;

    // Calculate total value
    for (var holdingData in userHoldingsData) {
      final priceData = prices[holdingData.coinId];
      if (priceData != null) {
        final valueUSD = priceData.usd * holdingData.amount;
        totalValue += valueUSD;
      }
    }

    // Create holdings with percentages
    for (var holdingData in userHoldingsData) {
      final priceData = prices[holdingData.coinId];
      if (priceData != null) {
        final valueUSD = priceData.usd * holdingData.amount;
        final changePercentage = priceData.usd24hChange;
        final changeAmount = (valueUSD * changePercentage) / (100 + changePercentage);
        final percentage = totalValue > 0 ? (valueUSD / totalValue) * 100 : 0.0;

        holdings.add(Holding(
          coinId: holdingData.coinId,
          name: holdingData.name,
          symbol: holdingData.symbol,
          iconPath: holdingData.imageUrl,
          amount: holdingData.amount,
          valueUSD: valueUSD,
          changeAmount: changeAmount,
          changePercentage: changePercentage,
          percentage: percentage,
        ));
      }
    }

    return holdings;
  }

  List<Transaction> _getMockTransactions() {
    return [
      Transaction(
        coinName: 'Bitcoin',
        type: TransactionType.buy,
        amount: 0.01,
        symbol: 'BTC',
        valueUSD: 452.50,
        timeAgo: '2 hours ago',
      ),
      Transaction(
        coinName: 'Ethereum',
        type: TransactionType.sell,
        amount: 0.5,
        symbol: 'ETH',
        valueUSD: 1050.25,
        timeAgo: '1 day ago',
      ),
    ];
  }
}