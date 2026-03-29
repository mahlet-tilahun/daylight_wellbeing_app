// test/mood/mood_entity_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:daylight_wellbeing_app/features/mood/domain/entities/mood_entity.dart';

void main() {
  test('MoodEntity equality uses all fields', () {
    final moodOne = MoodEntity(
      moodId: 'mood-001',
      userId: 'user-123',
      moodType: 'Great',
      note: 'Feeling good today',
      createdAt: DateTime(2025, 4, 1, 10, 0),
    );
    final moodTwo = MoodEntity(
      moodId: 'mood-001',
      userId: 'user-123',
      moodType: 'Great',
      note: 'Feeling good today',
      createdAt: DateTime(2025, 4, 1, 10, 0),
    );

    expect(moodOne, equals(moodTwo));
    expect(moodOne.hashCode, equals(moodTwo.hashCode));
  });
}
