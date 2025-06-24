part of 'injection_container.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => CacheHelper(sl()))
    ..registerLazySingleton(() => prefs);
}
