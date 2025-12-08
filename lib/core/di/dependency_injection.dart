import 'package:get_it/get_it.dart';
import '../../features/home/data/repository/home_repository.dart';
import '../network/api_service.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void initializeDependencies() {
  sl.registerLazySingleton(() => DioClient.createDio());
  sl.registerLazySingleton(() => ApiService(sl()));
  sl.registerLazySingleton(() => HomeRepository(apiService: sl()));
  sl.registerFactory(() => HomeCubit(repository: sl()));
}
