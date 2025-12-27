import 'package:crypto_tracker/features/auth/presentation/cubit/biometric_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
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

void initializeDependencies() async {
  sl.registerLazySingleton(() => DioClient.createDio());
  sl.registerLazySingleton(() => ApiService(sl()));
  sl.registerLazySingleton(() => PortfolioStorage());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerSingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance(),);

  // Repositories
  sl.registerLazySingleton(() => HomeRepository(apiService: sl()));
  sl.registerLazySingleton(() => MarketRepository(apiService: sl()));
  sl.registerLazySingleton(() => DetailsRepository(apiService: sl()));
  sl.registerLazySingleton(() => PortfolioRepository(apiService: sl(), portfolioStorage: sl()));
  sl.registerLazySingleton(() => PaymentRepository(apiService: sl()));
  sl.registerLazySingleton(() => EmailRepository());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()));

  // Cubits
  sl.registerFactory(() => HomeCubit(repository: sl()));
  sl.registerFactory(() => MarketCubit(repository: sl()));
  sl.registerFactory(() => DetailsCubit(repository: sl()));
  sl.registerFactory(() => PortfolioCubit(repository: sl()));
  sl.registerFactory(() => PaymentCubit(repository: sl()));
  sl.registerLazySingleton(() => AuthCubit(sl()));
  sl.registerFactory(() => BiometricCubit(sl<AuthRepository>(), sl<AuthCubit>()));


  // Ensure all async singletons are ready
  await sl.allReady();
}
