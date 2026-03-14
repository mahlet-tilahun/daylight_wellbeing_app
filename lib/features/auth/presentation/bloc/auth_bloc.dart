// lib/features/auth/presentation/bloc/auth_bloc.dart
// Handles auth events and emits the appropriate states.
// UI never talks to Firebase directly — it only talks to this BLoC.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/get_current_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LoginWithGoogle loginWithGoogle;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.loginWithGoogle,
    required this.registerUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithEmailRequested>(_onLoginWithEmail);
    on<LoginWithGoogleRequested>(_onLoginWithGoogle);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  /// Check if user is already logged in when app starts
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await getCurrentUser();
    if (result.isSuccess && result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle email/password login
  Future<void> _onLoginWithEmail(
    LoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  /// Handle Google sign-in
  Future<void> _onLoginWithGoogle(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginWithGoogle();
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  /// Handle new user registration
  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await registerUser(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  /// Handle logout
  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await logoutUser();
    if (result.isSuccess) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthError(result.error!));
    }
  }
}
