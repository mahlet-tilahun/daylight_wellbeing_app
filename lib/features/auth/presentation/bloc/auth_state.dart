// All possible UI states for the auth feature.

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// App just started, haven't checked auth yet
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Checking if user is logged in, or waiting for Firebase
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated — holds the current user
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// User is not authenticated (logged out or never logged in)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Something went wrong — holds the error message to display
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
