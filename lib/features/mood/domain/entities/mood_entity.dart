// lib/features/mood/domain/entities/mood_entity.dart
// Represents a single mood log entry.

import 'package:equatable/equatable.dart';

class MoodEntity extends Equatable {
  final String moodId;
  final String userId;
  final String moodType; // 'Great', 'Calm', 'Okay', 'Sad'
  final DateTime createdAt;

  const MoodEntity({
    required this.moodId,
    required this.userId,
    required this.moodType,
    required this.createdAt,
  });

  @override
  List<Object> get props => [moodId, userId, moodType, createdAt];
}
