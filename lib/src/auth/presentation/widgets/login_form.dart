import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, obscurePassword, __) {
              return VerticalLabelField(
                label: 'Password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter your password',
                obscureText: obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                    !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              );
            },
          ),
          const Gap(20),
          SizedBox(
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  context.push(ForgotPasswordScreen.path);
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyles.paragraphSubTextRegular1.primary,
                ),
              ),
            ),
          ),
          const Gap(40),
          RoundedButton(
            text: 'Sign In',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // TODO(Sign-In): Implement Sign in Functionality here
              }
            },
          ).loading(false),
        ],
      ),
    );
  }
}
