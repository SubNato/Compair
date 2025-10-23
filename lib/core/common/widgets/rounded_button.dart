import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    super.key,
    this.onPressed,
    this.height,
    this.padding,
    this.textStyle,
    this.backgroundColour,
    this.cart,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColour;
  final bool? cart;

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
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cart == true ? const Icon(Icons.check_circle_rounded) : const SizedBox.shrink(),
            cart == true ? const Gap(10) : const SizedBox.shrink(),
            Text(
              text,
              style: textStyle ?? TextStyles.buttonTextHeadingSemiBold.white,
            ),
          ],
        ),
      ),
    );
  }
}

