import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
    return MaterialApp(
      title: 'Compair',
      themeMode: ThemeMode.system,
      theme: theme,
      darkTheme: theme.copyWith(
        scaffoldBackgroundColor: Colours.darkThemeBGDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colours.darkThemeBGDark,
          foregroundColor: Colours.lightThemeWhiteColour,
        )
      ),
      home: Scaffold(
        body: Center(
          child: Text('Hello World!', style: TextStyles.headingRegular.copyWith(
            color: Colours.classicAdaptiveTextColour(context),
          ),),
        ),
      )
    );
  }
}