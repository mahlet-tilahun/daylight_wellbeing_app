// lib/features/mood/domain/entities/mood_entity.dart
// Represents a single mood log entry.

import 'package:equatable/equatable.dart';

class MoodEntity extends Equatable {
  final String moodId;
  final String userId;
  final String moodType; // 'Great', 'Calm', 'Okay', 'Sad'
  final String note;     // optional user note on the mood
  final DateTime createdAt;

  const MoodEntity({
    required this.moodId,
    required this.userId,
    required this.moodType,
    this.note = '',
    required this.createdAt,
  });

  MoodEntity copyWith({String? note}) {
    return MoodEntity(
      moodId: moodId,
      userId: userId,
      moodType: moodType,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }

  @override
  List<Object> get props => [moodId, userId, moodType, note, createdAt];
}
