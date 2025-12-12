import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../data/models/coin_model.dart';
import '../../data/models/coin_search_model.dart';
import '../../data/repository/market_repository.dart';
import 'market_states.dart';

class MarketCubit extends Cubit<MarketState> {
  final MarketRepository repository;

  List<CoinModel> allCoins = [];
  List<CoinSearchModel> searchResults = [];
  Timer? _debounce;

  MarketCubit({required this.repository}) : super(MarketInitial());

  // Load coin list
  Future<void> loadCoinList() async {
    emit(CoinListLoading());

    final result = await repository.getCoinList(perPage: 50, page: 1);

    result.fold(
          (failure) => emit(CoinListError(failure)),
          (coins) {
        allCoins = coins;
        emit(CoinListLoaded(coins));
      },
    );
  }

  // Search coins
  void searchCoins(String keyword) {
    _debounce?.cancel();

    if (keyword.trim().isEmpty) {
      emit(CoinListLoaded(allCoins));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(keyword.trim());
    });
  }

  // Perform actual search
  Future<void> _performSearch(String keyword) async {
    emit(SearchLoading());

    final result = await repository.searchCoins(keyword);

    result.fold(
          (failure) => emit(SearchError(failure)),
          (results) {
        if (results.isEmpty) {
          emit(SearchEmpty());
        } else {
          searchResults = results;
          emit(SearchLoaded(results));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}