// lib/features/mood/domain/usecases/mood_usecases.dart
// All mood use cases in one file for simplicity.

import '../../../../core/usecases/usecase.dart';
import '../entities/mood_entity.dart';
import '../repositories/mood_repository.dart';

// ── Add Mood ──────────────────────────────────────────────
class AddMood extends UseCase<MoodEntity, AddMoodParams> {
  final MoodRepository repository;
  AddMood(this.repository);

  @override
  Future<Result<MoodEntity>> call(AddMoodParams params) {
    return repository.addMood(
      userId: params.userId,
      moodType: params.moodType,
    );
  }
}

class AddMoodParams {
  final String userId;
  final String moodType;
  const AddMoodParams({required this.userId, required this.moodType});
}

// ── Get Moods ─────────────────────────────────────────────
class GetMoods extends UseCase<List<MoodEntity>, GetMoodsParams> {
  final MoodRepository repository;
  GetMoods(this.repository);

  @override
  Future<Result<List<MoodEntity>>> call(GetMoodsParams params) {
    return repository.getMoods(userId: params.userId);
  }
}

class GetMoodsParams {
  final String userId;
  const GetMoodsParams({required this.userId});
}

// ── Delete Mood ───────────────────────────────────────────
class DeleteMood extends UseCase<void, DeleteMoodParams> {
  final MoodRepository repository;
  DeleteMood(this.repository);

  @override
  Future<Result<void>> call(DeleteMoodParams params) {
    return repository.deleteMood(moodId: params.moodId);
  }
}

class DeleteMoodParams {
  final String moodId;
  const DeleteMoodParams({required this.moodId});
}
