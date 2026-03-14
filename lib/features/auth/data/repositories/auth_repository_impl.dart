// Implements the abstract AuthRepository from the domain layer.
// Catches exceptions from datasource and converts to Results.

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(e.message);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<UserEntity>> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(e.message);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<UserEntity>> loginWithGoogle() async {
    try {
      final user = await remoteDataSource.loginWithGoogle();
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(e.message);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Result.success(user);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }
}
