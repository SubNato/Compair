import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({required this.email, super.key});

  final String email;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, obscurePassword, __) {
              return VerticalLabelField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                    !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    switch (obscurePassword) {
                      true => Icons.visibility_off_outlined,
                      _ => Icons.visibility_outlined,
                    },
                  ),
                ),
              );
            },
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, obscureConfirmPassword, __) {
              return VerticalLabelField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureConfirmPassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                    !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(
                    switch (obscureConfirmPassword) {
                      true => Icons.visibility_off_outlined,
                      _ => Icons.visibility_outlined,
                    },
                  ),
                ),
                validator: (value) {
                  if (value! != passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              );
            },
          ),
          const Gap(40),
          RoundedButton(
            text: 'Submit',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // TODO(Reset-Password): Implement resetPassword functionality.
              }
            },
          ).loading(false),
        ],
      ),
    );
  }
}
