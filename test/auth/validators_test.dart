// test/auth/validators_test.dart
// Unit tests for input validators — no mocking needed.

import 'package:flutter_test/flutter_test.dart';
import 'package:daylight/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('returns null for a valid email', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
    });

    test('returns error for empty email', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.validateEmail('notanemail'), isNotNull);
      expect(Validators.validateEmail('missing@dot'), isNotNull);
    });
  });

  group('Validators.validatePassword', () {
    test('returns null for a valid password', () {
      expect(Validators.validatePassword('secure123'), isNull);
    });

    test('returns error for empty password', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('returns error for password shorter than 6 chars', () {
      expect(Validators.validatePassword('abc'), isNotNull);
      expect(Validators.validatePassword('12345'), isNotNull);
    });

    test('accepts password of exactly 6 characters', () {
      expect(Validators.validatePassword('abcdef'), isNull);
    });
  });

  group('Validators.validateName', () {
    test('returns null for valid name', () {
      expect(Validators.validateName('Maya'), isNull);
    });

    test('returns error for empty name', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName(null), isNotNull);
    });

    test('returns error for single character name', () {
      expect(Validators.validateName('A'), isNotNull);
    });
  });
}
