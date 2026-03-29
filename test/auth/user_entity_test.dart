// test/auth/user_entity_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/entities/user_entity.dart';

void main() {
  test('UserEntity equality uses all properties', () {
    final first = UserEntity(
      uid: 'uid-001',
      name: 'Maya',
      email: 'maya@test.com',
      createdAt: DateTime(2025, 1, 1),
    );
    final second = UserEntity(
      uid: 'uid-001',
      name: 'Maya',
      email: 'maya@test.com',
      createdAt: DateTime(2025, 1, 1),
    );

    expect(first, equals(second));
    expect(first.hashCode, equals(second.hashCode));
  });
}
