import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/compair_logo.dart';
import 'package:compair_hub/core/common/widgets/menu_icon.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/home/presentation/widgets/reactive_cart_icon.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adaptiveColour = Colours.classicAdaptiveTextColour(context);
    final currentProductType = ref.watch(productTypeNotifierProvider);

    return AppBar(
      leading: const MenuIcon(),
      centerTitle: false,
      titleSpacing: 0,
      title: GestureDetector(
        onDoubleTap: () {
          print("++++++++++++++++++++++++++++++++++++++ Double tap detected ++++++++++++++++++++++++++++++++++++++");

          //Here we toggle the product type
          ref.read(productTypeNotifierProvider.notifier).toggleType();

          //Snackbar to tell the user that the type was changed.
          CoreUtils.showSnackBar(
              context,
              message: 'Switched to ${ref.read(productTypeNotifierProvider).title}',
          );

          print("----------------------------- Product type was changed to: ${ref.read(productTypeNotifierProvider).title}");
        },
        child: CompairLogo(
          style: TextStyles.headingSemiBold.copyWith(
            color: CoreUtils.adaptiveColour(
              context,
              lightModeColour: Colours.lightThemePrimaryColour,
              darkModeColour: Colours.lightThemePrimaryTint,
            ),
          ),
        ),
      ),
      bottom: const AppBarBottom(),
      actions: [
        const ReactiveCartIcon(),
        const Gap(20),
        Icon(IconlyBold.scan, color: adaptiveColour),
        const Gap(20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
