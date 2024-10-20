import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shareindia/core/config/flavor_config.dart';
import 'package:shareindia/core/network/network_info.dart';
import 'package:shareindia/data/remote/dio_logging_interceptor.dart';
import 'package:shareindia/data/remote/remote_data_source.dart';
import 'package:shareindia/data/repository/apis_repository_impl.dart';
import 'package:shareindia/domain/repository/apis_repository.dart';
import 'package:shareindia/domain/usecase/master_data_usecase.dart';
import 'package:shareindia/domain/usecase/services_usecase.dart';
import 'package:shareindia/domain/usecase/user_usecase.dart';
import 'package:shareindia/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:shareindia/presentation/bloc/services/services_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      userUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ServicesBloc(
      servicesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => MasterDataBloc(
      masterDataUseCase: sl(),
    ),
  );
  // Use Case
  sl.registerLazySingleton(() => ServicesUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => UserUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => MasterDataUseCase(apisRepository: sl()));

  // Repository
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: sl()));

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.portalBaseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    var adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    dio.httpClientAdapter = adapter;
    return dio;
  });
}
