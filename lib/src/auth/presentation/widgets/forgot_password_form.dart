import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/auth/presentation/app/adapter/auth_adapter.dart';
import 'package:compair_hub/src/auth/presentation/views/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final familyKey = GlobalKey();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(authAdapterProvider(familyKey), (_, next) {
      if (next is AuthError) {
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is OTPSent) {
        context.push(
          VerifyOTPScreen.path,
          extra: emailController.text.trim(),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authAdapterProvider(familyKey));

    return Form(
      key: formKey,
      child: Column(
        children: [
          if (authState case AuthError(:final message))
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: Colors.pinkAccent.shade100.withOpacity(.4),
              ),
              child: Text(
                message,
                style: TextStyles.paragraphRegular.apply(color: Colors.red),
              ),
            ),
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(40),
          RoundedButton(
            text: 'Continue',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref
                    .read(authAdapterProvider(familyKey).notifier)
                    .forgotPassword(
                  email: emailController.text.trim(),
                );
              }
            },
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
