// lib/features/journal/domain/repositories/notes_repository.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/note_entity.dart';

abstract class NotesRepository {
  Future<Result<NoteEntity>> addNote({
    required String userId,
    required String title,
    required String content,
  });

  Future<Result<List<NoteEntity>>> getNotes({required String userId});

  Future<Result<NoteEntity>> updateNote({
    required String noteId,
    required String title,
    required String content,
  });

  Future<Result<void>> deleteNote({required String noteId});

  Future<Result<void>> toggleFavorite({
    required String noteId,
    required bool isFavorite,
  });
}
