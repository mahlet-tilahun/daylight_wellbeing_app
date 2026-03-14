// lib/features/notes/domain/usecases/notes_usecases.dart

import '../../../../core/usecases/usecase.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

// ── Add Note ──────────────────────────────────────────────
class AddNote extends UseCase<NoteEntity, AddNoteParams> {
  final NotesRepository repository;
  AddNote(this.repository);

  @override
  Future<Result<NoteEntity>> call(AddNoteParams params) {
    return repository.addNote(
      userId: params.userId,
      title: params.title,
      content: params.content,
    );
  }
}

class AddNoteParams {
  final String userId;
  final String title;
  final String content;
  const AddNoteParams({
    required this.userId,
    required this.title,
    required this.content,
  });
}

// ── Get Notes ─────────────────────────────────────────────
class GetNotes extends UseCase<List<NoteEntity>, GetNotesParams> {
  final NotesRepository repository;
  GetNotes(this.repository);

  @override
  Future<Result<List<NoteEntity>>> call(GetNotesParams params) {
    return repository.getNotes(userId: params.userId);
  }
}

class GetNotesParams {
  final String userId;
  const GetNotesParams({required this.userId});
}

// ── Update Note ───────────────────────────────────────────
class UpdateNote extends UseCase<NoteEntity, UpdateNoteParams> {
  final NotesRepository repository;
  UpdateNote(this.repository);

  @override
  Future<Result<NoteEntity>> call(UpdateNoteParams params) {
    return repository.updateNote(
      noteId: params.noteId,
      title: params.title,
      content: params.content,
    );
  }
}

class UpdateNoteParams {
  final String noteId;
  final String title;
  final String content;
  const UpdateNoteParams({
    required this.noteId,
    required this.title,
    required this.content,
  });
}

// ── Delete Note ───────────────────────────────────────────
class DeleteNote extends UseCase<void, DeleteNoteParams> {
  final NotesRepository repository;
  DeleteNote(this.repository);

  @override
  Future<Result<void>> call(DeleteNoteParams params) {
    return repository.deleteNote(noteId: params.noteId);
  }
}

class DeleteNoteParams {
  final String noteId;
  const DeleteNoteParams({required this.noteId});
}

// ── Toggle Favorite ───────────────────────────────────────
class ToggleFavorite extends UseCase<void, ToggleFavoriteParams> {
  final NotesRepository repository;
  ToggleFavorite(this.repository);

  @override
  Future<Result<void>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(
      noteId: params.noteId,
      isFavorite: params.isFavorite,
    );
  }
}

class ToggleFavoriteParams {
  final String noteId;
  final bool isFavorite;
  const ToggleFavoriteParams({required this.noteId, required this.isFavorite});
}
