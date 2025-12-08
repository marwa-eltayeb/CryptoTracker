import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/result.dart';
import '../models/coin_market_model.dart';
import '../models/global_market_model.dart';
import '../models/trending_model.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository({required this.apiService});

  Future<Result<GlobalMarketModel>> getMarketOverview() async {
    final result = await apiService.get(APIConstants.marketOverview);
    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(GlobalMarketModel.fromJson(response.data));
        } catch (e) {
          return FailureResult(GeneralFailure(errMessage: e.toString()));
        }
      },
    );
  }

  Future<Result<List<TrendingModel>>> getTrending() async {
    final result = await apiService.get(APIConstants.trendingCoins);
    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          final coinsData = response.data['coins'];
          if (coinsData == null || coinsData is! List) {
            return FailureResult(GeneralFailure(
              errMessage: 'Invalid trending coins response',
            ));
          }

          final list = (coinsData)
              .take(5)
              .map((e) => TrendingModel.fromJson(e))
              .toList();

          return Success(list);
        } catch (e) {
          return FailureResult(GeneralFailure(
            errMessage: 'Parsing trending coins failed: $e',
          ));
        }
      },
    );
  }

  Future<Result<List<CoinMarketModel>>> getTopGainers() async {
    final result = await apiService.get(APIConstants.topGainers, query: {
      'vs_currency': 'usd',
      'per_page': 100,
      'page': 1,
      'price_change_percentage': '24h',
      'sparkline': 'false',
    });

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          final allCoins = (response.data as List)
              .map((e) => CoinMarketModel.fromJson(e))
              .where((coin) => coin.priceChange > 0)
              .toList();

          allCoins.sort((a, b) => b.priceChange.compareTo(a.priceChange));

          return Success(allCoins.take(3).toList());
        } catch (e) {
          return FailureResult(GeneralFailure(
            errMessage: 'Parsing top gainers failed: $e',
          ));
        }
      },
    );
  }

}