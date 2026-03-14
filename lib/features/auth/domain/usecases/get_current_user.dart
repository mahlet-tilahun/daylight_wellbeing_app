// lib/features/auth/domain/usecases/get_current_user.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser extends UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  @override
  Future<Result<UserEntity?>> call() => repository.getCurrentUser();
}
