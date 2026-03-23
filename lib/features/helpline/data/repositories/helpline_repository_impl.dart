// lib/features/helpline/data/repositories/helpline_repository_impl.dart

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/helpline_entity.dart';
import '../../domain/repositories/helpline_repository.dart';
import '../datasources/helpline_local_datasource.dart';

class HelplineRepositoryImpl implements HelplineRepository {
  final HelplineLocalDataSource localDataSource;
  HelplineRepositoryImpl({required this.localDataSource});

  @override
  Result<List<HelplineEntity>> getHelplines() {
    try {
      final helplines = localDataSource.getHelplines();
      return Result.success(helplines);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
