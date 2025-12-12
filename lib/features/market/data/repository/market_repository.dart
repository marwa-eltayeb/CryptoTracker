import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/result.dart';
import '../models/coin_model.dart';
import '../models/coin_search_model.dart';
import '../models/coin_search_response.dart';

class MarketRepository {
  final ApiService apiService;

  MarketRepository({required this.apiService});

  // Get coin list
  Future<Result<List<CoinModel>>> getCoinList({int perPage = 50, int page = 1}) async {
    final result = await apiService.get(
      APIConstants.coinMarkets,
      query: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
    );

    return result.fold((failure) => FailureResult(failure), (response) {
        try {
          final List<dynamic> data = response.data as List<dynamic>;
          final coins = data
              .map((json) => CoinModel.fromJson(json as Map<String, dynamic>))
              .toList();
          return Success(coins);
        } catch (e) {
          return FailureResult(GeneralFailure(errMessage: e.toString()));
        }
      },
    );
  }

  // Search coins by keyword
  Future<Result<List<CoinSearchModel>>> searchCoins(String keyword) async {
    if (keyword.isEmpty) {
      return Success([]);
    }

    final result = await apiService.get(
      APIConstants.searchCoins,
      query: {
        'query': keyword,
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          final searchResponse = CoinSearchResponse.fromJson(response.data);
          return Success(searchResponse.coins);
        } catch (e) {
          return FailureResult(GeneralFailure(errMessage: e.toString()));
        }
      },
    );
  }
}