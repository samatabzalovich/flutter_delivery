part of 'dependencies_injector.dart';

GetIt sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl
    //packages
    ..registerSingleton(Dio())
    //DataSources
    ..registerSingleton<AuthApiService>(AuthApiServiceImpl(baseUrl+routeUrl, sl()))
    ..registerSingleton<AuthLocalService>(AuthLocalServiceImpl())
    //Repositories
    ..registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()))
    //Bloc
    ..registerFactory(() => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl()))
    //UseCases
    ..registerLazySingleton(() => CheckUserTokenUseCase(sl()))
    ..registerLazySingleton(() => LogInUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetTokenUseCase(sl()))
    ..registerLazySingleton(() => SetTokenUseCase(sl()));
}
