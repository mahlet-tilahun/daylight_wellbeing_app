// lib/features/auth/domain/usecases/login_with_google.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle extends UseCaseNoParams<UserEntity> {
  final AuthRepository repository;
  LoginWithGoogle(this.repository);

  @override
  Future<Result<UserEntity>> call() => repository.loginWithGoogle();
}
