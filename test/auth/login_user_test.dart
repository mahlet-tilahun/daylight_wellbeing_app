// test/auth/login_user_test.dart
// Unit test for the LoginUser use case.
// We mock the repository so we're only testing the use case logic.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:daylight_wellbeing_app/core/usecases/usecase.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/entities/user_entity.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/usecases/auth_usecases.dart';

// Create a mock of the repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUser loginUser;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUser = LoginUser(mockRepository);
  });

  group('LoginUser use case', () {
    test('should return a UserEntity when login succeeds', () async {
      // ARRANGE: tell the mock what to return
      final successUser = UserEntity(
        uid: 'uid-123',
        name: 'Maya',
        email: 'maya@test.com',
        createdAt: DateTime(2024, 1, 1),
      );

      when(
        () => mockRepository.loginWithEmail(
          email: 'maya@test.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => Result.success(successUser));

      // ACT: call the use case
      final result = await loginUser(
        const LoginParams(email: 'maya@test.com', password: 'password123'),
      );

      // ASSERT: check the result
      expect(result.isSuccess, true);
      expect(result.data?.email, 'maya@test.com');
      expect(result.data?.name, 'Maya');

      // Verify the repository method was called exactly once
      verify(
        () => mockRepository.loginWithEmail(
          email: 'maya@test.com',
          password: 'password123',
        ),
      ).called(1);
    });

    test('should return a failure when login fails', () async {
      // ARRANGE: mock returns a failure
      when(
        () => mockRepository.loginWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure('No account found with this email.'),
      );

      // ACT
      final result = await loginUser(
        const LoginParams(email: 'wrong@test.com', password: 'wrongpass'),
      );

      // ASSERT
      expect(result.isFailure, true);
      expect(result.error, 'No account found with this email.');
    });
  });
}
