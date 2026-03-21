// lib/features/journal/data/repositories/notes_repository_impl.dart

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  NotesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<NoteEntity>> addNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    try {
      final note = await remoteDataSource.addNote(
          userId: userId, title: title, content: content);
      return Result.success(note);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<List<NoteEntity>>> getNotes({required String userId}) async {
    try {
      final notes = await remoteDataSource.getNotes(userId: userId);
      return Result.success(notes);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<NoteEntity>> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      final note = await remoteDataSource.updateNote(
          noteId: noteId, title: title, content: content);
      return Result.success(note);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<void>> deleteNote({required String noteId}) async {
    try {
      await remoteDataSource.deleteNote(noteId: noteId);
      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }

  @override
  Future<Result<void>> toggleFavorite({
    required String noteId,
    required bool isFavorite,
  }) async {
    try {
      await remoteDataSource.toggleFavorite(
          noteId: noteId, isFavorite: isFavorite);
      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    }
  }
}
