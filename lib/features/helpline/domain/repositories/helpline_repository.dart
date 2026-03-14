// lib/features/helpline/domain/repositories/helpline_repository.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/helpline_entity.dart';

abstract class HelplineRepository {
  Result<List<HelplineEntity>> getHelplines();
}
