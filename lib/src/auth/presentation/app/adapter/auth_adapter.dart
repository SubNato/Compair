import 'package:compair_hub/core/common/app/riverpod/current_user_provider.dart';
import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/auth/domain/usecases/forgot_password.dart';
import 'package:compair_hub/src/auth/domain/usecases/login.dart';
import 'package:compair_hub/src/auth/domain/usecases/register.dart';
import 'package:compair_hub/src/auth/domain/usecases/reset_password.dart';
import 'package:compair_hub/src/auth/domain/usecases/verify_o_t_p.dart';
import 'package:compair_hub/src/auth/domain/usecases/verify_token.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_adapter.g.dart'; //Generated using command in console: 'dart run build_runner build watch --delete-conflicting-outputs'
part 'auth_state.dart'; //We do this in order to have access to the states in auth_state class!

@riverpod
class AuthAdapter extends _$AuthAdapter {
  //Remember, this is a template.

  @override
  AuthState build([GlobalKey? familyKey]) {
    //The return type of this build method is whatever you are waiting for to change.
    _forgotPassword = sl<ForgotPassword>();
    _login = sl<Login>();
    _register = sl<Register>();
    _resetPassword = sl<ResetPassword>();
    _verifyOTP = sl<VerifyOTP>();
    _verifyToken = sl<VerifyToken>();

    return const AuthInitial(); //There MUST be a return value, or initial value when the user logs on or opens the screen.
  }

  late ForgotPassword _forgotPassword;
  late Login _login;
  late Register _register;
  late ResetPassword _resetPassword;
  late VerifyOTP _verifyOTP;
  late VerifyToken _verifyToken;

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await _login(LoginParams(
      email: email,
      password: password,
    ));
    result.fold((failure) => state = AuthError(failure.errorMessage), (user) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = LoggedIn(user);
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String parish,
    required String phone,
  }) async {
    state = const AuthLoading();
    final result = await _register(RegisterParams(
      name: name,
      password: password,
      parish: parish,
      email: email,
      phone: phone,
    ));
    result.fold(
      (failure) => state = AuthError(failure.errorMessage),
      (_) => state = const Registered(),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AuthLoading();
    final result = await _forgotPassword(email);
    result.fold(
          (failure) => state = AuthError(failure.errorMessage),
          (_) => state = const OTPSent(),
    );
  }

  Future<void> verifyOTP({required String email, required String otp}) async {
    state = const AuthLoading();
    final result = await _verifyOTP(VerifyOTPParams(email: email, otp: otp));
    result.fold(
          (failure) => state = AuthError(failure.errorMessage),
          (_) => state = const OTPVerified(),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = const AuthLoading();
    final result = await _resetPassword(
      ResetPasswordParams(email: email, newPassword: newPassword),
    );
    result.fold(
          (failure) => state = AuthError(failure.errorMessage),
          (_) => state = const PasswordReset(),
    );
  }

  Future<void> verifyToken() async {
    state = const AuthLoading();
    final result = await _verifyToken();
    result.fold((failure) => state = AuthError(failure.errorMessage),
            (isValid) {
          state = TokenVerified(isValid);
          if (!isValid) ref.read(currentUserProvider.notifier).setUser(null);
        });
  }
}