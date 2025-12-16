import '../../data/models/coin_detail_model.dart';
import '../../data/models/price_chart_model.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

// Coin Details States
class CoinDetailsLoading extends DetailsState {}

class CoinDetailsLoaded extends DetailsState {
  final CoinDetailModel coinDetail;

  CoinDetailsLoaded({required this.coinDetail});
}

class CoinDetailsError extends DetailsState {
  final String message;

  CoinDetailsError({required this.message});
}

// Chart States
class ChartLoading extends DetailsState {}

class ChartLoaded extends DetailsState {
  final List<ChartDataPoint> chartData;
  final String selectedPeriod;

  ChartLoaded({
    required this.chartData,
    required this.selectedPeriod,
  });
}

class ChartError extends DetailsState {
  final String errorMessage;
  final String selectedPeriod;

  ChartError({
    required this.errorMessage,
    required this.selectedPeriod,
  });
}