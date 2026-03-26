// lib/features/auth/presentation/bloc/auth_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

/// Emitted after a password reset email is successfully sent
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

/// Emitted after registration — user needs to verify email before proceeding
class AuthEmailNotVerified extends AuthState {
  const AuthEmailNotVerified();
}

/// Emitted when resend was successful
class AuthVerificationEmailSent extends AuthState {
  const AuthVerificationEmailSent();
}
