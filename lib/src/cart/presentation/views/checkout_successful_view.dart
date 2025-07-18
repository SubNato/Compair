import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/media.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/src/dashboard/presentation/app/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class CheckoutSuccessfulView extends ConsumerWidget {
  const CheckoutSuccessfulView({super.key});

  static const path = '/checkout-completed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Media.checkMark, repeat: false),
            Text(
              'Your order has been placed',
              textAlign: TextAlign.center,
              style:
                  TextStyles.buttonTextHeadingSemiBold.adaptiveColour(context),
            ),
            const Gap(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedButton(
                height: 50,
                onPressed: () {
                  DashboardState.instance.changeIndex(0);
                  context.go('/', extra: 'home');
                },
                text: 'Continue Shopping   🛒',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
