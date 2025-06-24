import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/media.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/cupertino.dart';

class OnBoardingInfoSection extends StatelessWidget {
  const OnBoardingInfoSection.first({super.key}) : first = true;

  const OnBoardingInfoSection.second({super.key}) : first = false;

  final bool first;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(first ? Media.onBoardingFemale : Media.onBoardingMale),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            switch(first) {
            true => Text.rich(
              textAlign: TextAlign.left,
              TextSpan(
                text: '${DateTime.now().year}\n',
                style: TextStyles.headingBold.orange,
                children: [
                  TextSpan(
                    text: 'Winter Sale is live now',
                    style: TextStyle(
                        color: Colours.classicAdaptiveTextColour(context),
                    ),
                  ),
                ],
              ),
            ),
            _ => Text.rich(
              textAlign: TextAlign.left,
              TextSpan(
                text: 'Flash Sale\n',
                style: TextStyles.headingBold.adaptiveColour(context),
                children: [
                  const TextSpan(
                    text: "Men's ",
                    style: TextStyle(
                        color: Colours.lightThemeSecondaryTextColour,
                    ),
                  ),
                  TextSpan(
                    text: ' Shirt and Watches',
                    style: TextStyle(
                      color: Colours.classicAdaptiveTextColour(context),
                    )
                  )
                ],
              ),
            ),
            }
          ],
        )
      ],
    );
  }
}
