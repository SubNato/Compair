import 'package:compair_hub/core/common/app/cache_helper.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/core/services/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  sl<CacheHelper>().getThemeMode();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colours.lightThemePrimaryColour,),
      fontFamily: 'Switzer', //Remember that this is licenced. Find out about using it for a launched app!
      scaffoldBackgroundColor: Colours.lightThemeTintStockColour,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colours.lightThemeTintStockColour,
        foregroundColor: Colours.lightThemePrimaryTextColour,
      ),
      useMaterial3: true,
    );
    return ValueListenableBuilder(
        valueListenable: Cache.instance.themeModeNotifier,
        builder: (_, themeMode, __) {
          return MaterialApp.router(
            title: 'Compair',
            routerConfig: router,
            themeMode: themeMode,
            theme: theme,
            darkTheme: theme.copyWith(
              scaffoldBackgroundColor: Colours.darkThemeBGDark,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colours.darkThemeBGDark,
                foregroundColor: Colours.lightThemeWhiteColour,
              ),
            ),
          );
        }
    );
  }
}