part of 'dependencies_injector.dart';

GetIt sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl
  //services
  ..registerLazySingleton<SocketService>(() => SocketService(serviceUrl))
    ..registerLazySingleton<LocationService>(() => LocationService())
    ..registerLazySingleton<GoogleMapsApiService>(() => GoogleMapsApiServiceImpl(sl()))
    ..registerLazySingleton<GoogleMapsHelper>(() => GoogleMapsHelper())
    //packages
    ..registerSingleton(Dio())
    ..registerLazySingleton(() => PolylinePoints())
    //DataSources
    ..registerSingleton<AuthApiService>(AuthApiServiceImpl(baseUrl+routeUrl, sl()))
    ..registerSingleton<AuthLocalService>(AuthLocalServiceImpl())
    ..registerLazySingleton<SocketApiService>(() => SocketApiServiceImpl(sl()))
    ..registerFactory<SocketStreamApiService>(()=>SocketStreamApiServiceImpl(sl()))
    ..registerFactory<SocketServiceMessage>(()=>SocketServiceErrorImpl(sl()))
    //Repositories
    ..registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()))
    ..registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(sl(), sl(), sl(), sl()))
    //Bloc
    ..registerFactory(() => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl()))
    ..registerFactory(() => DeliveryBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()))
    //common use cases
    ..registerLazySingleton(() => OffLineUseCase(sl()))
        ..registerLazySingleton(() => ServerMessageUseCase(sl()))
            ..registerLazySingleton(() => GetPolylineUseCase(sl()))

    //auth UseCases
    ..registerLazySingleton(() => CheckUserTokenUseCase(sl()))
    ..registerLazySingleton(() => LogInUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetTokenUseCase(sl()))
    ..registerLazySingleton(() => SetTokenUseCase(sl()))
    //delivery use cases
    ..registerLazySingleton(() => InitializeUseCase(sl()))
    ..registerLazySingleton(() => OnLineUseCase(sl()))
    ..registerLazySingleton(() => StreamOrderUseCase(sl()))
    ..registerLazySingleton(() => AcceptOrderUseCase(sl()))
    ..registerLazySingleton(() => SendLocationUseCase(sl()))
    ..registerLazySingleton(() => PickOrderUseCase(sl()))
    ..registerLazySingleton(() => CompleteOrderUseCase(sl()))
    ..registerLazySingleton(() => DisconnectUsecase(sl()))
    ..registerLazySingleton(() => CloseErrorStreamUseCase(sl()))
    ..registerLazySingleton(() => CloseSocketStreamUseCase(sl()));
}
