import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/enums/product_type.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompairLogo extends ConsumerWidget {
  const CompairLogo({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productType = ref.watch(productTypeNotifierProvider);

    return Text.rich(
      TextSpan(
        text: 'Com',
        style:  productType == ProductType.autoPart ? (style ?? TextStyles.appLogo.white) : TextStyles.headingSemiBold.copyWith(
          color: Colours.lightThemeSecondaryColour,
        ),
        children: [
          TextSpan(
            text: 'pare',
            style: productType == ProductType.autoPart ? const TextStyle(
              color: Colours.lightThemeSecondaryColour,
            ) : (style ?? TextStyles.appLogo.white),
          ),
        ],
      ),
    );
  }
}


// Before for 'Com': style ?? TextStyles.appLogo.white
//
// Before for 'pare': const TextStyle(
//               color: Colours.lightThemeSecondaryColour,
//             )
//