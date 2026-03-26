// lib/features/auth/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class LoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginWithEmailRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Fired when user submits the forgot password form
class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class EmailVerificationCheckRequested extends AuthEvent {
  const EmailVerificationCheckRequested();
}

class ResendVerificationEmailRequested extends AuthEvent {
  const ResendVerificationEmailRequested();
}
