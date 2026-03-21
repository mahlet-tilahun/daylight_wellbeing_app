// lib/features/auth/domain/repositories/auth_repository.dart

import '../entities/user_entity.dart';
import '../../../../core/usecases/usecase.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> loginWithGoogle();

  Future<Result<void>> logout();

  Future<Result<UserEntity?>> getCurrentUser();

  /// Sends a password reset email to the given address
  Future<Result<void>> sendPasswordResetEmail({required String email});
}
