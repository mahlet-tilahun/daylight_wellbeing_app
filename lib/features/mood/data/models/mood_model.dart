// lib/features/mood/data/models/mood_model.dart

import '../../domain/entities/mood_entity.dart';

class MoodModel extends MoodEntity {
  const MoodModel({
    required super.moodId,
    required super.userId,
    required super.moodType,
    required super.createdAt,
  });

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      moodId: map['moodId'] as String,
      userId: map['userId'] as String,
      moodType: map['moodType'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moodId': moodId,
      'userId': userId,
      'moodType': moodType,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
