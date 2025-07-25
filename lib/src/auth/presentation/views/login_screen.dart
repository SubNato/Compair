import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/auth/presentation/views/registration_screen.dart';
import 'package:compair_hub/src/auth/presentation/widgets/login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();

}
  class _LoginScreenState extends ConsumerState<LoginScreen> {
    @override void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) { //Ensures that the state is mounted before executing anything
        final uri = Uri.parse(GoRouterState
            .of(context)
            .uri
            .toString());
        final isRegistered = uri.queryParameters['registered'] == 'true';

        if (isRegistered) {
          CoreUtils.postFrameCall(() {
            CoreUtils.showSnackBar(context, message: 'Registration Successful!');
            context.go(LoginScreen.path); //Takes out the query params that we entered in register screen
          });
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyles.headingSemiBold),
        bottom: const AppBarBottom(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              children: [
                Text(
                  'Hello!!',
                  style: TextStyles.headingBold3.adaptiveColour(context),
                ),
                Text(
                  'Sign in with your account details',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                const Gap(40),
                const LoginForm(),
              ],
            ),
          ),
          const Gap(8),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyles.paragraphSubTextRegular3.grey,
              children: [
                TextSpan(
                  text: 'Create Account',
                  style: const TextStyle(
                    color: Colours.lightThemePrimaryColour,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.go(RegistrationScreen.path),
                ),
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
