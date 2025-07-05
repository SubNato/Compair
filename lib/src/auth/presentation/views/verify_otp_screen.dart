import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/auth/presentation/app/adapter/auth_adapter.dart';
import 'package:compair_hub/src/auth/presentation/views/reset_password_screen.dart';
import 'package:compair_hub/src/auth/presentation/widgets/otp_fields.dart';
import 'package:compair_hub/src/auth/presentation/widgets/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  const VerifyOTPScreen({required this.email, super.key});

  static const path = '/verify-otp';

  final String email;

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  final otpController = TextEditingController();
  final familyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.listenManual(authAdapterProvider(familyKey), (previous, next) {
      if (next is AuthError) {
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is OTPVerified) {
        context.pushReplacement(
          ResetPasswordScreen.path,
          extra: widget.email,
        );
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authAdapterProvider(familyKey));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyles.headingSemiBold,
        ),
        bottom: const AppBarBottom(),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        children: [
          Text(
            'Verification Code',
            style: TextStyles.headingBold3.adaptiveColour(context),
          ),
          Text(
            'Code has been sent to ${widget.email.obscureEmail}',
            style: TextStyles.paragraphSubTextRegular1.grey,
          ),
          const Gap(20),
          OTPFields(controller: otpController),
          const Gap(30),
          OTPTimer(
            email: widget.email,
            familyKey: familyKey,
          ),
          const Gap(40),
          RoundedButton(
            text: 'Verify',
            onPressed: () {
              if (otpController.text.length < 4) {
                CoreUtils.showSnackBar(context, message: 'Invalid OTP');
              } else {
                ref.read(authAdapterProvider(familyKey).notifier).verifyOTP(
                  email: widget.email,
                  otp: otpController.text.trim(),
                );
              }
            },
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
