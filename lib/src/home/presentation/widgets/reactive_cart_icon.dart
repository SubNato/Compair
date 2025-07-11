import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/src/cart/presentation/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class ReactiveCartIcon extends StatefulWidget {
  const ReactiveCartIcon({super.key});

  @override
  State<ReactiveCartIcon> createState() => _ReactiveCartIconState();
}

class _ReactiveCartIconState extends State<ReactiveCartIcon> {
  // TODO(Implementation): Make this react to cart state changes
  final countNotifier = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(CartView.path),
      child: ValueListenableBuilder(
        valueListenable: countNotifier,
        builder: (_, value, __) {
          return Badge(
            backgroundColor: Colours.lightThemeSecondaryColour,
            isLabelVisible: value != null && value > 0,
            label: Center(
              child: Text(value.toString(), style: const TextStyle().white),
            ),
            child: Icon(
              IconlyBroken.buy,
              size: 24,
              color: Colours.classicAdaptiveTextColour(context),
            ),
          );
        },
      ),
    );
  }
}
