import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/result.dart';
import '../models/coin_detail_model.dart';
import '../models/price_chart_model.dart';

class DetailsRepository {

  final ApiService apiService;
  DetailsRepository({required this.apiService});

  // Get Coin Details
  Future<Result<CoinDetailModel>> getCoinDetails(String coinId) async {
    final endpoint = APIConstants.coinDetails.replaceAll('{id}', coinId);

    final result = await apiService.get(
      endpoint,
      query: {
        'localization': 'false',
        'tickers': 'false',
        'community_data': 'false',
        'developer_data': 'false',
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(CoinDetailModel.fromJson(response.data));
        } catch (e) {
          return FailureResult(GeneralFailure(
            errMessage: 'Parsing coin details failed: $e',
          ));
        }
      },
    );
  }

  // Get Coin Market Chart
  Future<Result<PriceChartModel>> getCoinMarketChart({
    required String coinId,
    required String days,
  }) async {
    final endpoint = APIConstants.coinMarketChart.replaceAll('{id}', coinId);

    final result = await apiService.get(
      endpoint,
      query: {
        'vs_currency': 'usd',
        'days': days,
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(PriceChartModel.fromJson(response.data));
        } catch (e) {
          return FailureResult(GeneralFailure(
            errMessage: 'Parsing chart data failed: $e',
          ));
        }
      },
    );
  }

}