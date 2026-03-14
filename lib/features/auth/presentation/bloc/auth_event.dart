// lib/features/auth/presentation/bloc/auth_event.dart
// All possible actions the user can trigger in auth screens.

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the app starts — checks if user is already logged in
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired when user submits the login form
class LoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Fired when user taps "Sign in with Google"
class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}

/// Fired when user submits the registration form
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

/// Fired when user taps the logout button
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
