// lib/features/journal/presentation/bloc/notes_bloc.dart
// Events, States, and BLoC for the notes feature.

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/notes_usecases.dart';

// ── EVENTS ────────────────────────────────────────────────

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotesRequested extends NotesEvent {
  final String userId;
  const LoadNotesRequested(this.userId);
  @override
  List<Object> get props => [userId];
}

class AddNoteRequested extends NotesEvent {
  final String userId;
  final String title;
  final String content;
  const AddNoteRequested({
    required this.userId,
    required this.title,
    required this.content,
  });
  @override
  List<Object> get props => [userId, title, content];
}

class UpdateNoteRequested extends NotesEvent {
  final String noteId;
  final String userId;
  final String title;
  final String content;
  const UpdateNoteRequested({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.content,
  });
  @override
  List<Object> get props => [noteId, userId, title, content];
}

class DeleteNoteRequested extends NotesEvent {
  final String noteId;
  final String userId;
  const DeleteNoteRequested({required this.noteId, required this.userId});
  @override
  List<Object> get props => [noteId, userId];
}

class ToggleFavoriteRequested extends NotesEvent {
  final String noteId;
  final String userId;
  final bool isFavorite;
  const ToggleFavoriteRequested({
    required this.noteId,
    required this.userId,
    required this.isFavorite,
  });
  @override
  List<Object> get props => [noteId, userId, isFavorite];
}

// ── STATES ────────────────────────────────────────────────

abstract class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;
  const NotesLoaded(this.notes);
  @override
  List<Object> get props => [notes];
}

class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);
  @override
  List<Object> get props => [message];
}

// ── BLOC ──────────────────────────────────────────────────

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final AddNote addNote;
  final GetNotes getNotes;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final ToggleFavorite toggleFavorite;

  NotesBloc({
    required this.addNote,
    required this.getNotes,
    required this.updateNote,
    required this.deleteNote,
    required this.toggleFavorite,
  }) : super(const NotesInitial()) {
    on<LoadNotesRequested>(_onLoad);
    on<AddNoteRequested>(_onAdd);
    on<UpdateNoteRequested>(_onUpdate);
    on<DeleteNoteRequested>(_onDelete);
    on<ToggleFavoriteRequested>(_onToggleFavorite);
  }

  Future<void> _onLoad(
      LoadNotesRequested event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await getNotes(GetNotesParams(userId: event.userId));
    if (result.isSuccess) {
      emit(NotesLoaded(result.data!));
    } else {
      emit(NotesError(result.error!));
    }
  }

  Future<void> _onAdd(
      AddNoteRequested event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await addNote(AddNoteParams(
      userId: event.userId,
      title: event.title,
      content: event.content,
    ));
    if (result.isSuccess) {
      // Reload all notes after adding
      final notes = await getNotes(GetNotesParams(userId: event.userId));
      emit(notes.isSuccess
          ? NotesLoaded(notes.data!)
          : NotesError(notes.error!));
    } else {
      emit(NotesError(result.error!));
    }
  }

  Future<void> _onUpdate(
      UpdateNoteRequested event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await updateNote(UpdateNoteParams(
      noteId: event.noteId,
      title: event.title,
      content: event.content,
    ));
    if (result.isSuccess) {
      final notes = await getNotes(GetNotesParams(userId: event.userId));
      emit(notes.isSuccess
          ? NotesLoaded(notes.data!)
          : NotesError(notes.error!));
    } else {
      emit(NotesError(result.error!));
    }
  }

  Future<void> _onDelete(
      DeleteNoteRequested event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await deleteNote(DeleteNoteParams(noteId: event.noteId));
    if (result.isSuccess) {
      final notes = await getNotes(GetNotesParams(userId: event.userId));
      emit(notes.isSuccess
          ? NotesLoaded(notes.data!)
          : NotesError(notes.error!));
    } else {
      emit(NotesError(result.error!));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteRequested event, Emitter<NotesState> emit) async {
    // Optimistic update — change UI immediately, then confirm with backend
    final currentState = state;
    if (currentState is NotesLoaded) {
      final updatedNotes = currentState.notes.map((note) {
        if (note.noteId == event.noteId) {
          return note.copyWith(isFavorite: event.isFavorite);
        }
        return note;
      }).toList();
      emit(NotesLoaded(updatedNotes));
    }

    final result = await toggleFavorite(ToggleFavoriteParams(
      noteId: event.noteId,
      isFavorite: event.isFavorite,
    ));
    if (result.isFailure) {
      // Revert on failure
      final notes = await getNotes(GetNotesParams(userId: event.userId));
      emit(notes.isSuccess
          ? NotesLoaded(notes.data!)
          : NotesError(notes.error!));
    }
  }
}
