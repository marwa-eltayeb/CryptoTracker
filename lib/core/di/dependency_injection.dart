import 'package:get_it/get_it.dart';
import '../../features/details/data/repository/details_repository.dart';
import '../../features/details/presentation/cubit/details_cubit.dart';
import '../../features/home/data/repository/home_repository.dart';
import '../../features/market/data/repository/market_repository.dart';
import '../../features/market/presentation/cubit/market_cubit.dart';
import '../network/api_service.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void initializeDependencies() {
  sl.registerLazySingleton(() => DioClient.createDio());
  sl.registerLazySingleton(() => ApiService(sl()));

  // Repositories
  sl.registerLazySingleton(() => HomeRepository(apiService: sl()));
  sl.registerLazySingleton(() => MarketRepository(apiService: sl()));
  sl.registerLazySingleton(() => DetailsRepository(apiService: sl()));

  // Cubits
  sl.registerFactory(() => HomeCubit(repository: sl()));
  sl.registerFactory(() => MarketCubit(repository: sl()));
  sl.registerFactory(() => DetailsCubit(repository: sl()));

}
