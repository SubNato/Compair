import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  static const path = '/explore';

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text('EXPLORE', style: TextStyles.headingBold.white),
    );
  }
}
