import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../data/models/coin_model.dart';
import '../../data/models/coin_search_model.dart';
import '../../data/repository/market_repository.dart';
import 'market_states.dart';

class MarketCubit extends Cubit<MarketState> {

  final MarketRepository repository;
  MarketCubit({required this.repository}) : super(MarketInitial());

  List<CoinModel> allCoins = [];
  List<CoinSearchModel> searchResults = [];
  Timer? _debounce;

  // Pagination variables
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _paginationError;

  // Getters for pagination state
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  String? get paginationError => _paginationError;

  // Load coin list
  Future<void> loadCoinList() async {
    emit(CoinListLoading());
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false;
    _paginationError = null;

    final result = await repository.getCoinList(
      perPage: 50,
      page: _currentPage,
    );

    result.fold((failure) => emit(CoinListError(failure)), (coins) {
      allCoins = coins;
      _hasMoreData = coins.length >= 50;
      emit(CoinListLoaded(coins));
    });
  }

  // Load more coins
  Future<void> loadMoreCoins() async {
    if (_isLoadingMore || !_hasMoreData) {
      return;
    }

    if (state is! CoinListLoaded) {
      return;
    }

    _isLoadingMore = true;
    _paginationError = null;
    emit(CoinListLoaded(allCoins));
    _currentPage++;

    final result = await repository.getCoinList(
      perPage: 50,
      page: _currentPage,
    );

    result.fold(
      (failure) {
        _currentPage--;
        _isLoadingMore = false;
        _paginationError = failure.errMessage;
        emit(CoinListLoaded(allCoins));
      },
      (coins) {
        if (coins.isEmpty || coins.length < 50) {
          _hasMoreData = false;
        }

        allCoins.addAll(coins);
        _isLoadingMore = false;
        _paginationError = null;
        emit(CoinListLoaded(allCoins));
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

    result.fold((failure) => emit(SearchError(failure)), (results) {
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        searchResults = results;
        emit(SearchLoaded(results));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
