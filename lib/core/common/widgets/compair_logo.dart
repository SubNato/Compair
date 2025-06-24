import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class CompairLogo extends StatelessWidget {
  const CompairLogo({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Com',
        style: style ?? TextStyles.appLogo.white,
        children: const [
          TextSpan(
            text: 'pair',
            style: TextStyle(
              color: Colours.lightThemeSecondaryColour,
            ),
          ),
        ],
      ),
    );
  }
}
