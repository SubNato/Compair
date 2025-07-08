import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  static const path = '/wishlist';

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text('WISHLIST', style: TextStyles.headingBold.white),
    );
  }
}
