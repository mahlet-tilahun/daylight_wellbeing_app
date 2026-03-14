// lib/features/auth/domain/usecases/register_user.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

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
