import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final double height;
  final bool? cart;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.height = 10,
    this.cart = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          onPressed: onPressed,
          //focusColor: Colours.lightThemePrimaryTextColour,
          foregroundColor: Colours.lightThemeWhiteColour,
          backgroundColor: cart == true ? Colors.green : Colours.lightThemePrimaryColour,
          shape: const CircleBorder(),
          child: icon,
        );
      //),
  }
}
