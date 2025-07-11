part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _cacheInit();
  await _authInit();
  await _userInit();
  await _productInit();
}

Future<void> _productInit() async {
  sl
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => GetCategory(sl()))
    ..registerLazySingleton(() => GetNewArrivals(sl()))
    ..registerLazySingleton(() => GetPopular(sl()))
    ..registerLazySingleton(() => GetProduct(sl()))
    ..registerLazySingleton(() => GetProductReviews(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetProductsByCategory(sl()))
    ..registerLazySingleton(() => LeaveReview(sl()))
    ..registerLazySingleton(() => SearchAllProducts(sl()))
    ..registerLazySingleton(() => SearchByCategory(sl()))
    ..registerLazySingleton(() => SearchByCategoryAndGenderAgeCategory(sl()))
    ..registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()))
    ..registerLazySingleton<ProductRemoteDataSrc>(
          () => ProductRemoteDataSrcImpl(sl()),
    );
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
