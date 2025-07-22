import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';

class UploadFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const UploadFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10, //For adjusting the height above the bottom bar
      left: 0,
      right: 0,
      child: Center(
        child: FloatingActionButton(
          onPressed: onPressed,
          //focusColor: Colours.lightThemePrimaryTextColour,
          foregroundColor: Colours.lightThemeWhiteColour,
          backgroundColor: Colours.lightThemePrimaryColour,
          shape: const CircleBorder(),
          child: icon,
        ),
      ),
    );
  }
}
