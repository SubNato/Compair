part of 'auth_adapter.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//The Initial State
final class AuthInitial extends AuthState {
  const AuthInitial();
}

//The general Loading States. Can have different loading states for different classes.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

//The Success States
final class OTPSent extends AuthState {
  const OTPSent();
}

final class LoggedIn extends AuthState {
  const LoggedIn(this.user);

  final User user;

  @override
  List<Object?> get props => [];
}

final class Registered extends AuthState {
  const Registered();
}

final class PasswordReset extends AuthState {
  const PasswordReset();
}

final class OTPVerified extends AuthState {
  const OTPVerified();
}

final class TokenVerified extends AuthState {
  const TokenVerified(this.isValid);

  final bool isValid;

  @override
  List<Object?> get props => [isValid];
}

//The Error State
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}