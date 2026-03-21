// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LoginWithGoogle loginWithGoogle;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;
  final SendPasswordReset sendPasswordReset;

  AuthBloc({
    required this.loginUser,
    required this.loginWithGoogle,
    required this.registerUser,
    required this.logoutUser,
    required this.getCurrentUser,
    required this.sendPasswordReset,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithEmailRequested>(_onLoginWithEmail);
    on<LoginWithGoogleRequested>(_onLoginWithGoogle);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<ForgotPasswordRequested>(_onForgotPassword);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await getCurrentUser();
    if (result.isSuccess && result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoginWithEmail(
      LoginWithEmailRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await loginUser(
        LoginParams(email: event.email, password: event.password));
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await loginWithGoogle();
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _onRegister(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await registerUser(RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _onLogout(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await logoutUser();
    if (result.isSuccess) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await sendPasswordReset(
        SendPasswordResetParams(email: event.email));
    if (result.isSuccess) {
      emit(const AuthPasswordResetSent());
    } else {
      emit(AuthError(result.error!));
    }
  }
}
