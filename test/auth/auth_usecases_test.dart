// test/auth/auth_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:daylight_wellbeing_app/core/usecases/usecase.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/entities/user_entity.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/usecases/auth_usecases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUser loginUser;
  late LoginWithGoogle loginWithGoogle;
  late RegisterUser registerUser;
  late LogoutUser logoutUser;
  late GetCurrentUser getCurrentUser;
  late SendPasswordReset sendPasswordReset;
  late CheckEmailVerified checkEmailVerified;
  late ResendVerificationEmail resendVerificationEmail;

  final testUser = UserEntity(
    uid: 'uid-001',
    name: 'Maya',
    email: 'maya@test.com',
    createdAt: DateTime(2025, 1, 1),
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUser = LoginUser(mockRepository);
    loginWithGoogle = LoginWithGoogle(mockRepository);
    registerUser = RegisterUser(mockRepository);
    logoutUser = LogoutUser(mockRepository);
    getCurrentUser = GetCurrentUser(mockRepository);
    sendPasswordReset = SendPasswordReset(mockRepository);
    checkEmailVerified = CheckEmailVerified(mockRepository);
    resendVerificationEmail = ResendVerificationEmail(mockRepository);
  });

  test('LoginUser forwards credentials to repository', () async {
    when(
      () => mockRepository.loginWithEmail(
        email: 'maya@test.com',
        password: 'password123',
      ),
    ).thenAnswer((_) async => Result.success(testUser));

    final result = await loginUser(
      const LoginParams(email: 'maya@test.com', password: 'password123'),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data, testUser);
    verify(
      () => mockRepository.loginWithEmail(
        email: 'maya@test.com',
        password: 'password123',
      ),
    ).called(1);
  });

  test('LoginWithGoogle forwards the repository call', () async {
    when(
      () => mockRepository.loginWithGoogle(),
    ).thenAnswer((_) async => Result.success(testUser));

    final result = await loginWithGoogle();

    expect(result.isSuccess, isTrue);
    expect(result.data, testUser);
    verify(() => mockRepository.loginWithGoogle()).called(1);
  });

  test('RegisterUser forwards registration params', () async {
    when(
      () => mockRepository.registerWithEmail(
        name: 'Maya',
        email: 'maya@test.com',
        password: 'secret123',
      ),
    ).thenAnswer((_) async => Result.success(testUser));

    final result = await registerUser(
      const RegisterParams(
        name: 'Maya',
        email: 'maya@test.com',
        password: 'secret123',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data, testUser);
    verify(
      () => mockRepository.registerWithEmail(
        name: 'Maya',
        email: 'maya@test.com',
        password: 'secret123',
      ),
    ).called(1);
  });

  test('LogoutUser forwards the logout call', () async {
    when(
      () => mockRepository.logout(),
    ).thenAnswer((_) async => const Result.success(null));

    final result = await logoutUser();

    expect(result.isSuccess, isTrue);
    verify(() => mockRepository.logout()).called(1);
  });

  test('GetCurrentUser forwards current user request', () async {
    when(
      () => mockRepository.getCurrentUser(),
    ).thenAnswer((_) async => Result.success(testUser));

    final result = await getCurrentUser();

    expect(result.isSuccess, isTrue);
    expect(result.data, testUser);
    verify(() => mockRepository.getCurrentUser()).called(1);
  });

  test('SendPasswordReset forwards reset email', () async {
    when(
      () => mockRepository.sendPasswordResetEmail(email: 'test@test.com'),
    ).thenAnswer((_) async => const Result.success(null));

    final result = await sendPasswordReset(
      const SendPasswordResetParams(email: 'test@test.com'),
    );

    expect(result.isSuccess, isTrue);
    verify(
      () => mockRepository.sendPasswordResetEmail(email: 'test@test.com'),
    ).called(1);
  });

  test('CheckEmailVerified forwards verification check', () async {
    when(
      () => mockRepository.isEmailVerified(),
    ).thenAnswer((_) async => const Result.success(true));

    final result = await checkEmailVerified();

    expect(result.isSuccess, isTrue);
    expect(result.data, isTrue);
    verify(() => mockRepository.isEmailVerified()).called(1);
  });

  test('ResendVerificationEmail forwards resend call', () async {
    when(
      () => mockRepository.resendVerificationEmail(),
    ).thenAnswer((_) async => const Result.success(null));

    final result = await resendVerificationEmail();

    expect(result.isSuccess, isTrue);
    verify(() => mockRepository.resendVerificationEmail()).called(1);
  });
}
