import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    super.key,
    this.onPressed,
    this.height,
    this.padding,
    this.textStyle,
    this.backgroundColour,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 66,
      width: double.maxFinite,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: backgroundColour,
          padding: padding,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed?.call();
        },
        child: Text(
          text,
          style: textStyle ?? TextStyles.buttonTextHeadingSemiBold.white,
        ),
      ),
    );
  }
}

