import 'package:get_it/get_it.dart';
import '../../features/details/data/repository/details_repository.dart';
import '../../features/details/presentation/cubit/details_cubit.dart';
import '../../features/home/data/repository/home_repository.dart';
import '../../features/market/data/repository/market_repository.dart';
import '../../features/market/presentation/cubit/market_cubit.dart';
import '../../features/payment/data/repository/email_repository.dart';
import '../../features/payment/data/repository/payment_repository.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../../features/portfolio/data/repository/portfolio_repository.dart';
import '../../features/portfolio/presentation/cubit/portfolio_cubit.dart';
import '../network/api_service.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../network/dio_client.dart';
import '../storage/portfolio_storage.dart';

final sl = GetIt.instance;

void initializeDependencies() {
  sl.registerLazySingleton(() => DioClient.createDio());
  sl.registerLazySingleton(() => ApiService(sl()));
  sl.registerLazySingleton(() => PortfolioStorage());

  // Repositories
  sl.registerLazySingleton(() => HomeRepository(apiService: sl()));
  sl.registerLazySingleton(() => MarketRepository(apiService: sl()));
  sl.registerLazySingleton(() => DetailsRepository(apiService: sl()));
  sl.registerLazySingleton(() => PortfolioRepository(apiService: sl(), portfolioStorage: sl()));
  sl.registerLazySingleton(() => PaymentRepository(apiService: sl()));
  sl.registerLazySingleton(() => EmailRepository());

  // Cubits
  sl.registerFactory(() => HomeCubit(repository: sl()));
  sl.registerFactory(() => MarketCubit(repository: sl()));
  sl.registerFactory(() => DetailsCubit(repository: sl()));
  sl.registerFactory(() => PortfolioCubit(repository: sl()));
  sl.registerFactory(() => PaymentCubit(repository: sl()));

}
