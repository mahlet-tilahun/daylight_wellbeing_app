// lib/features/mood/domain/repositories/mood_repository.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/mood_entity.dart';

abstract class MoodRepository {
  Future<Result<MoodEntity>> addMood({
    required String userId,
    required String moodType,
    String note,
  });

  Future<Result<List<MoodEntity>>> getMoods({required String userId});

  Future<Result<void>> deleteMood({required String moodId});

  /// Updates the text note on an existing mood entry
  Future<Result<void>> updateMoodNote({
    required String moodId,
    required String note,
  });
}
