import '../../../../core/errors/failures.dart';
import '../../data/models/coin_model.dart';
import '../../data/models/coin_search_model.dart';

abstract class MarketState {}

// Initial State
class MarketInitial extends MarketState {}

// Coin List States
class CoinListLoading extends MarketState {}

class CoinListLoaded extends MarketState {
  final List<CoinModel> coins;

  CoinListLoaded(this.coins);
}

class CoinListError extends MarketState {
  final Failures failure;
  CoinListError(this.failure);
}

// Search States
class SearchLoading extends MarketState {}

class SearchLoaded extends MarketState {
  final List<CoinSearchModel> searchResults;

  SearchLoaded(this.searchResults);
}

class SearchError extends MarketState {
  final Failures failure;
  SearchError(this.failure);
}

class SearchEmpty extends MarketState {}