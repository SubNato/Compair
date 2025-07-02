import 'package:country_picker/country_picker.dart';
import 'package:compair_hub/core/common/widgets/input_field.dart';
import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gap/gap.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  final countryNotifier = ValueNotifier<Country?>(null);

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (country) {
          if (country != countryNotifier.value) countryNotifier.value = country;
        });
  }

  @override
  void initState() {
    super.initState();
    countryNotifier.addListener(() {
      if (countryNotifier.value == null) {
        phoneController.clear();
        countryController.clear();
      } else {
        countryController.text = '+${countryNotifier.value!.phoneCode}';
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    countryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Full Name',
            controller: fullNameController,
            hintText: 'Enter your name',
            keyboardType: TextInputType.name,
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: countryNotifier,
            builder: (context, country, __) {
              return VerticalLabelField(
                label: 'Phone',
                enabled: country != null,
                hintText: 'Enter your phone number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (!isPhoneValid(
                    value!,
                    defaultCountryCode: country?.countryCode,
                  )) {
                    return 'Invalid Phone number';
                  }
                  return null;
                },
                inputFormatters: [
                  PhoneInputFormatter(defaultCountryCode: country?.countryCode),
                ],
                mainFieldFlex: 3,
                prefix: InputField(
                    controller: countryController,
                    defaultValidation: false,
                    readOnly: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    suffixIcon: GestureDetector(
                      onTap: pickCountry,
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                    suffixIconConstraints: const BoxConstraints(),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !isPhoneValid(
                            value,
                            defaultCountryCode: country?.countryCode,
                          )) {
                        return '';
                      }
                      return null;
                    }),
              );
            },
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
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, obscureConfirmPassword, __) {
              return VerticalLabelField(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Re-enter your password',
                  obscureText: obscureConfirmPassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      obscureConfirmPasswordNotifier.value =
                      !obscureConfirmPasswordNotifier.value;
                    },
                    child: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value! != passwordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    return null;
                  });
            },
          ),
          const Gap(40),
          RoundedButton(
            text: 'Sign Up',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // TODO(Registration): Implement Sign up Functionality here
              }
            },
          ).loading(false),
        ],
      ),
    );
  }
}
