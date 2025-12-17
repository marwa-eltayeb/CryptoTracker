import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/result.dart';
import '../../../../core/storage/portfolio_storage.dart';
import '../models/portfolio_price_model.dart';

class PortfolioRepository {
  final ApiService apiService;
  final PortfolioStorage portfolioStorage;

  PortfolioRepository({
    required this.apiService,
    required this.portfolioStorage,
  });

  Future<Result<PortfolioPriceModel>> getPortfolioPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) {
      return Success(PortfolioPriceModel(prices: {}));
    }

    final ids = coinIds.join(',');
    final queryParams = {
      'ids': ids,
      'vs_currencies': 'usd',
      'include_24hr_change': 'true',
    };

    final result = await apiService.get(
      APIConstants.simplePrice,
      query: queryParams,
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(PortfolioPriceModel.fromJson(response.data));
        } catch (e) {
          return FailureResult(GeneralFailure(errMessage: e.toString()));
        }
      },
    );
  }

  Future<List<CoinHoldingData>> getUserHoldings() async {
    return await portfolioStorage.getUserHoldings();
  }

  Future<void> addHolding(String coinId, String name, String symbol, double amount, String imageUrl) async {
    await portfolioStorage.addHolding(coinId, name, symbol, amount, imageUrl);
  }

  Future<void> updateHolding(String coinId, double amount) async {
    await portfolioStorage.updateHolding(coinId, amount);
  }

  Future<void> removeHolding(String coinId) async {
    await portfolioStorage.removeHolding(coinId);
  }
}