import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/coin_detail_model.dart';
import '../../data/models/price_chart_model.dart';
import '../../data/repository/details_repository.dart';
import 'details_states.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final DetailsRepository repository;

  DetailsCubit({required this.repository}) : super(DetailsInitial());

  String currentPeriod = '1d';
  bool _isUpdating = false;

  CoinDetailModel? _cachedCoinDetail;
  List<ChartDataPoint> _cachedChartData = [];

  CoinDetailModel? get coinDetail => _cachedCoinDetail;
  List<ChartDataPoint> get chartData => _cachedChartData;
  String get selectedPeriod => currentPeriod;

  // Load Coin Details
  Future<void> loadCoinDetails(String coinId) async {
    emit(CoinDetailsLoading());

    final detailsResult = await repository.getCoinDetails(coinId);

    detailsResult.fold(
          (failure) {
        emit(CoinDetailsError(message: failure.errMessage));
      },
          (detailsData) {
        _cachedCoinDetail = detailsData;
        emit(CoinDetailsLoaded(coinDetail: _cachedCoinDetail!));

        // Load initial chart data
        _loadChartData(coinId);
      },
    );
  }

  // Load Chart Data
  Future<void> _loadChartData(String coinId) async {
    emit(ChartLoading());

    final (days, _) = _periodToParams(currentPeriod);
    final chartResult = await repository.getCoinMarketChart(
      coinId: coinId,
      days: days,
    );

    chartResult.fold(
          (failure) {
        emit(ChartError(
          errorMessage: failure.errMessage,
          selectedPeriod: currentPeriod,
        ));
      },
          (chartData) {
        final chartModel = chartData;
        _cachedChartData = _optimizeChartData(chartModel.prices);
        emit(ChartLoaded(
          chartData: _cachedChartData,
          selectedPeriod: currentPeriod,
        ));
      },
    );
  }

  Future<void> updateChartPeriod(String coinId, String period) async {
    if (period == currentPeriod) return;
    if (_isUpdating) return;
    _isUpdating = true;
    currentPeriod = period;

    emit(ChartLoading());

    final (days, _) = _periodToParams(period);
    final result = await repository.getCoinMarketChart(
      coinId: coinId,
      days: days,
    );

    _isUpdating = false;

    result.fold(
          (failure) {
        emit(ChartError(
          errorMessage: failure.errMessage,
          selectedPeriod: period,
        ));
      },
          (chartData) {
        final chartModel = chartData;
        _cachedChartData = _optimizeChartData(chartModel.prices);
        emit(ChartLoaded(
          chartData: _cachedChartData,
          selectedPeriod: period,
        ));
      },
    );
  }

  (String, String?) _periodToParams(String period) {
    switch (period) {
      case '1d':
        return ('1', 'hourly');
      case '1w':
        return ('7', 'daily');
      case '1m':
        return ('30', 'daily');
      case '1y':
        return ('365', 'daily');
      default:
        return ('1', 'hourly');
    }
  }

  List<ChartDataPoint> _optimizeChartData(List<ChartDataPoint> data) {
    if (data.isEmpty || data.length <= 100) return data;

    final step = (data.length / 100).ceil();
    final optimized = <ChartDataPoint>[];

    for (int i = 0; i < data.length; i += step) {
      optimized.add(data[i]);
    }

    if (optimized.last.time != data.last.time) {
      optimized.add(data.last);
    }

    return optimized;
  }
}