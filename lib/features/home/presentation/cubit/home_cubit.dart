import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // Fetch all data concurrently
    final marketResult = await repository.getMarketOverview();
    final trendingResult = await repository.getTrending();
    final topGainersResult = await repository.getTopGainers();

    // Check for any failures
    if (marketResult.isFailure || trendingResult.isFailure || topGainersResult.isFailure) {
      return emit(
        HomeError(
          marketResult.failureOrNull ??
          trendingResult.failureOrNull ??
          topGainersResult.failureOrNull!,
        ),
      );
    }

    emit(
      HomeLoaded(
        market: marketResult.dataOrNull!,
        trendingData: trendingResult.dataOrNull!,
        topGainers: topGainersResult.dataOrNull!,
      ),
    );
  }
}
