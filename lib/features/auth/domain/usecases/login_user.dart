// lib/features/auth/domain/usecases/login_user.dart
// Use case for email/password login.
// Each use case does exactly ONE thing.

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

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
