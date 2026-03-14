// lib/features/auth/domain/usecases/logout_user.dart

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUser extends UseCaseNoParams<void> {
  final AuthRepository repository;
  LogoutUser(this.repository);

  @override
  Future<Result<void>> call() => repository.logout();
}
