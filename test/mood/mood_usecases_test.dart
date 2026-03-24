// test/mood/mood_usecases_test.dart
// Unit tests for all mood use cases.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:daylight/core/usecases/usecase.dart';
import 'package:daylight/features/mood/domain/entities/mood_entity.dart';
import 'package:daylight/features/mood/domain/repositories/mood_repository.dart';
import 'package:daylight/features/mood/domain/usecases/mood_usecases.dart';

class MockMoodRepository extends Mock implements MoodRepository {}

void main() {
  late MockMoodRepository mockRepo;
  late AddMood addMood;
  late GetMoods getMoods;
  late DeleteMood deleteMood;
  late UpdateMoodNote updateMoodNote;

  final testMood = MoodEntity(
    moodId: 'mood-001',
    userId: 'user-123',
    moodType: 'Great',
    note: 'Feeling good today',
    createdAt: DateTime(2025, 4, 1, 10, 0),
  );

  setUp(() {
    mockRepo = MockMoodRepository();
    addMood = AddMood(mockRepo);
    getMoods = GetMoods(mockRepo);
    deleteMood = DeleteMood(mockRepo);
    updateMoodNote = UpdateMoodNote(mockRepo);
  });

  group('AddMood', () {
    test('returns a MoodEntity on success', () async {
      when(
        () => mockRepo.addMood(
          userId: 'user-123',
          moodType: 'Great',
          note: 'Feeling good today',
        ),
      ).thenAnswer((_) async => Result.success(testMood));

      final result = await addMood(
        const AddMoodParams(
          userId: 'user-123',
          moodType: 'Great',
          note: 'Feeling good today',
        ),
      );

      expect(result.isSuccess, true);
      expect(result.data?.moodType, 'Great');
      expect(result.data?.note, 'Feeling good today');
    });

    test('returns failure when repository fails', () async {
      when(
        () => mockRepo.addMood(
          userId: any(named: 'userId'),
          moodType: any(named: 'moodType'),
          note: any(named: 'note'),
        ),
      ).thenAnswer((_) async => const Result.failure('Failed to add mood'));

      final result = await addMood(
        const AddMoodParams(userId: 'user-123', moodType: 'Sad'),
      );

      expect(result.isFailure, true);
      expect(result.error, 'Failed to add mood');
    });
  });

  group('GetMoods', () {
    test('returns list of moods on success', () async {
      when(
        () => mockRepo.getMoods(userId: 'user-123'),
      ).thenAnswer((_) async => Result.success([testMood]));

      final result = await getMoods(const GetMoodsParams(userId: 'user-123'));

      expect(result.isSuccess, true);
      expect(result.data?.length, 1);
      expect(result.data?.first.moodType, 'Great');
    });

    test('returns empty list when no moods exist', () async {
      when(
        () => mockRepo.getMoods(userId: any(named: 'userId')),
      ).thenAnswer((_) async => const Result.success([]));

      final result = await getMoods(const GetMoodsParams(userId: 'user-123'));

      expect(result.isSuccess, true);
      expect(result.data, isEmpty);
    });
  });

  group('DeleteMood', () {
    test('returns success when delete works', () async {
      when(
        () => mockRepo.deleteMood(moodId: 'mood-001'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await deleteMood(
        const DeleteMoodParams(moodId: 'mood-001'),
      );

      expect(result.isSuccess, true);
    });

    test('returns failure when delete fails', () async {
      when(
        () => mockRepo.deleteMood(moodId: any(named: 'moodId')),
      ).thenAnswer((_) async => const Result.failure('Permission denied'));

      final result = await deleteMood(
        const DeleteMoodParams(moodId: 'mood-001'),
      );

      expect(result.isFailure, true);
      expect(result.error, 'Permission denied');
    });
  });

  group('UpdateMoodNote', () {
    test('returns success when update works', () async {
      when(
        () => mockRepo.updateMoodNote(moodId: 'mood-001', note: 'Updated note'),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await updateMoodNote(
        const UpdateMoodNoteParams(moodId: 'mood-001', note: 'Updated note'),
      );

      expect(result.isSuccess, true);
      verify(
        () => mockRepo.updateMoodNote(moodId: 'mood-001', note: 'Updated note'),
      ).called(1);
    });

    test('returns failure when update fails', () async {
      when(
        () => mockRepo.updateMoodNote(
          moodId: any(named: 'moodId'),
          note: any(named: 'note'),
        ),
      ).thenAnswer((_) async => const Result.failure('Update failed'));

      final result = await updateMoodNote(
        const UpdateMoodNoteParams(moodId: 'mood-001', note: 'test'),
      );

      expect(result.isFailure, true);
    });
  });
}
