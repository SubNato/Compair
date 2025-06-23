import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';

abstract class CoreUtils {
  const CoreUtils();

  static Color adaptiveColour(
      BuildContext context, {
        required Color lightModeColour,
        required Color darkModeColour,
  }) {
    return context.isDarkMode //MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? darkModeColour
        : lightModeColour;
  }
}
