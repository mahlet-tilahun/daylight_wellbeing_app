// lib/features/auth/domain/repositories/auth_repository.dart
// Abstract contract — defines WHAT auth can do, not HOW.
// The Firebase implementation lives in the data layer.

import '../entities/user_entity.dart';
import '../../../../core/usecases/usecase.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Register a new user with email and password
  Future<Result<UserEntity>> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Result<UserEntity>> loginWithGoogle();

  /// Sign out the current user
  Future<Result<void>> logout();

  /// Get the currently logged-in user (null if not logged in)
  Future<Result<UserEntity?>> getCurrentUser();
}
