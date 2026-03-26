// lib/features/auth/domain/usecases/auth_usecases.dart
// All auth use cases in one file — mirrors the mood/notes pattern.

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// ── Login with Email ──────────────────────────────────────
class LoginUser extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  LoginUser(this.repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

// ── Login with Google ─────────────────────────────────────
class LoginWithGoogle extends UseCaseNoParams<UserEntity> {
  final AuthRepository repository;
  LoginWithGoogle(this.repository);

  @override
  Future<Result<UserEntity>> call() => repository.loginWithGoogle();
}

// ── Register ──────────────────────────────────────────────
class RegisterUser extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;
  RegisterUser(this.repository);

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return repository.registerWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

// ── Logout ────────────────────────────────────────────────
class LogoutUser extends UseCaseNoParams<void> {
  final AuthRepository repository;
  LogoutUser(this.repository);

  @override
  Future<Result<void>> call() => repository.logout();
}

// ── Get Current User ──────────────────────────────────────
class GetCurrentUser extends UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  @override
  Future<Result<UserEntity?>> call() => repository.getCurrentUser();
}

// ── Send Password Reset Email ─────────────────────────────
class SendPasswordReset extends UseCase<void, SendPasswordResetParams> {
  final AuthRepository repository;
  SendPasswordReset(this.repository);

  @override
  Future<Result<void>> call(SendPasswordResetParams params) {
    return repository.sendPasswordResetEmail(email: params.email);
  }
}

class SendPasswordResetParams {
  final String email;
  const SendPasswordResetParams({required this.email});
}

class CheckEmailVerified extends UseCaseNoParams<bool> {
  final AuthRepository repository;
  CheckEmailVerified(this.repository);

  @override
  Future<Result<bool>> call() => repository.isEmailVerified();
}

class ResendVerificationEmail extends UseCaseNoParams<void> {
  final AuthRepository repository;
  ResendVerificationEmail(this.repository);

  @override
  Future<Result<void>> call() => repository.resendVerificationEmail();
}
