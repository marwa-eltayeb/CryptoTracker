import 'package:flutter/cupertino.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/global_market_model.dart';
import '../../data/models/trending_model.dart';
import '../../data/models/coin_market_model.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final GlobalMarketModel market;
  final List<TrendingModel> trendingData;
  final List<CoinMarketModel> topGainers;

  const HomeLoaded({
    required this.market,
    required this.trendingData,
    required this.topGainers,
  });
}

class HomeError extends HomeState {
  final Failures failure;

  const HomeError(this.failure);
}
