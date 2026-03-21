// lib/features/mood/presentation/bloc/mood_bloc.dart
// Events, States, and BLoC all in one file for the mood feature.

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/mood_entity.dart';
import '../../domain/usecases/mood_usecases.dart';

// ── EVENTS ────────────────────────────────────────────────

abstract class MoodEvent extends Equatable {
  const MoodEvent();
  @override
  List<Object?> get props => [];
}

class LoadMoodsRequested extends MoodEvent {
  final String userId;
  const LoadMoodsRequested(this.userId);
  @override
  List<Object> get props => [userId];
}

class AddMoodRequested extends MoodEvent {
  final String userId;
  final String moodType;
  final String note;
  const AddMoodRequested({
    required this.userId,
    required this.moodType,
    this.note = '',
  });
  @override
  List<Object> get props => [userId, moodType, note];
}

class DeleteMoodRequested extends MoodEvent {
  final String moodId;
  final String userId;
  const DeleteMoodRequested({required this.moodId, required this.userId});
  @override
  List<Object> get props => [moodId, userId];
}

/// Allows editing the text note attached to an existing mood entry
class UpdateMoodNoteRequested extends MoodEvent {
  final String moodId;
  final String userId;
  final String note;
  const UpdateMoodNoteRequested({
    required this.moodId,
    required this.userId,
    required this.note,
  });
  @override
  List<Object> get props => [moodId, userId, note];
}

// ── STATES ────────────────────────────────────────────────

abstract class MoodState extends Equatable {
  const MoodState();
  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodLoaded extends MoodState {
  final List<MoodEntity> moods;
  const MoodLoaded(this.moods);
  @override
  List<Object> get props => [moods];
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
  @override
  List<Object> get props => [message];
}

// ── BLOC ──────────────────────────────────────────────────

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final AddMood addMood;
  final GetMoods getMoods;
  final DeleteMood deleteMood;
  final UpdateMoodNote updateMoodNote;

  MoodBloc({
    required this.addMood,
    required this.getMoods,
    required this.deleteMood,
    required this.updateMoodNote,
  }) : super(const MoodInitial()) {
    on<LoadMoodsRequested>(_onLoad);
    on<AddMoodRequested>(_onAdd);
    on<DeleteMoodRequested>(_onDelete);
    on<UpdateMoodNoteRequested>(_onUpdateNote);
  }

  Future<void> _onLoad(
      LoadMoodsRequested event, Emitter<MoodState> emit) async {
    emit(const MoodLoading());
    final result = await getMoods(GetMoodsParams(userId: event.userId));
    if (result.isSuccess) {
      emit(MoodLoaded(result.data!));
    } else {
      emit(MoodError(result.error!));
    }
  }

  Future<void> _onAdd(
      AddMoodRequested event, Emitter<MoodState> emit) async {
    emit(const MoodLoading());
    final result = await addMood(
      AddMoodParams(
        userId: event.userId,
        moodType: event.moodType,
        note: event.note,
      ),
    );
    if (result.isSuccess) {
      final moods = await getMoods(GetMoodsParams(userId: event.userId));
      if (moods.isSuccess) {
        emit(MoodLoaded(moods.data!));
      } else {
        emit(MoodError(moods.error!));
      }
    } else {
      emit(MoodError(result.error!));
    }
  }

  Future<void> _onDelete(
      DeleteMoodRequested event, Emitter<MoodState> emit) async {
    emit(const MoodLoading());
    final result =
        await deleteMood(DeleteMoodParams(moodId: event.moodId));
    if (result.isSuccess) {
      final moods = await getMoods(GetMoodsParams(userId: event.userId));
      if (moods.isSuccess) {
        emit(MoodLoaded(moods.data!));
      } else {
        emit(MoodError(moods.error!));
      }
    } else {
      emit(MoodError(result.error!));
    }
  }

  /// Optimistically update the note text, then confirm with backend
  Future<void> _onUpdateNote(
      UpdateMoodNoteRequested event, Emitter<MoodState> emit) async {
    // Optimistic update — show change in UI immediately
    final currentState = state;
    if (currentState is MoodLoaded) {
      final updated = currentState.moods.map((m) {
        if (m.moodId == event.moodId) return m.copyWith(note: event.note);
        return m;
      }).toList();
      emit(MoodLoaded(updated));
    }

    final result = await updateMoodNote(
      UpdateMoodNoteParams(moodId: event.moodId, note: event.note),
    );
    if (result.isFailure) {
      // Revert on failure
      final moods = await getMoods(GetMoodsParams(userId: event.userId));
      if (moods.isSuccess) {
        emit(MoodLoaded(moods.data!));
      } else {
        emit(MoodError(moods.error!));
      }
    }
  }
}
