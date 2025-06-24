import 'package:compair_hub/core/common/widgets/compair_logo.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colours.lightThemePrimaryColour,
        body: Center(child: CompairLogo()));
  }
}
