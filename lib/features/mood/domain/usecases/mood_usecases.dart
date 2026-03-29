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
      note: params.note,
    );
  }
}

class AddMoodParams {
  final String userId;
  final String moodType;
  final String note;
  const AddMoodParams({
    required this.userId,
    required this.moodType,
    this.note = '',
  });
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

// ── Update Mood Note ──────────────────────────────────────
// Allows user to add or edit a text note on an existing mood entry
class UpdateMoodNote extends UseCase<void, UpdateMoodNoteParams> {
  final MoodRepository repository;
  UpdateMoodNote(this.repository);

  @override
  Future<Result<void>> call(UpdateMoodNoteParams params) {
    return repository.updateMoodNote(
      moodId: params.moodId,
      note: params.note,
    );
  }
}

class UpdateMoodNoteParams {
  final String moodId;
  final String note;
  const UpdateMoodNoteParams({required this.moodId, required this.note});
}
