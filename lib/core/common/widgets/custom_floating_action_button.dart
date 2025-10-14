import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final double height;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          onPressed: onPressed,
          //focusColor: Colours.lightThemePrimaryTextColour,
          foregroundColor: Colours.lightThemeWhiteColour,
          backgroundColor: Colours.lightThemePrimaryColour,
          shape: const CircleBorder(),
          child: icon,
        );
      //),
  }
}
