part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _cacheInit();
  await _authInit();
}

Future<void> _userInit() async {
  sl
    ..registerLazySingleton(() => GetUser(sl()))
    ..registerLazySingleton(() => GetUserPaymentProfile(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<UserRepo>(() => UserRepoImpl(sl()))
    ..registerLazySingleton<UserRemoteDataSrc>(
          () => UserRemoteDataSrcImpl(sl()),
    );
}

Future<void> _authInit() async {
  sl
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(() => VerifyOTP(sl()))
    ..registerLazySingleton(() => VerifyToken(sl()))
    ..registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImplementation(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
            () => AuthRemoteDataSourceImplementation(sl()))
    ..registerLazySingleton(http.Client.new);
}

Future<void> _cacheInit() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => CacheHelper(sl()))
    ..registerLazySingleton(() => prefs);
}
