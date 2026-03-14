// lib/features/mood/data/repositories/mood_repository_impl.dart

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/mood_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_remote_datasource.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource remoteDataSource;
  MoodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<MoodEntity>> addMood({
    required String userId,
    required String moodType,
  }) async {
    try {
      final mood = await remoteDataSource.addMood(
          userId: userId, moodType: moodType);
      return Result.success(mood);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<List<MoodEntity>>> getMoods({required String userId}) async {
    try {
      final moods = await remoteDataSource.getMoods(userId: userId);
      return Result.success(moods);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<void>> deleteMood({required String moodId}) async {
    try {
      await remoteDataSource.deleteMood(moodId: moodId);
      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }
}
