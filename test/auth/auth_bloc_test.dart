// test/auth/auth_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:daylight_wellbeing_app/core/usecases/usecase.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/entities/user_entity.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:daylight_wellbeing_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_state.dart';

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

  AuthBloc buildBloc() {
    return AuthBloc(
      loginUser: loginUser,
      loginWithGoogle: loginWithGoogle,
      registerUser: registerUser,
      logoutUser: logoutUser,
      getCurrentUser: getCurrentUser,
      sendPasswordReset: sendPasswordReset,
      checkEmailVerified: checkEmailVerified,
      resendVerificationEmail: resendVerificationEmail,
    );
  }

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthAuthenticated when login succeeds and email is verified',
    setUp: () {
      when(
        () => mockRepository.loginWithEmail(
          email: 'maya@test.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.isEmailVerified(),
      ).thenAnswer((_) async => const Result.success(true));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const LoginWithEmailRequested(
        email: 'maya@test.com',
        password: 'password123',
      ),
    ),
    expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthError when login fails',
    setUp: () {
      when(
        () => mockRepository.loginWithEmail(
          email: 'maya@test.com',
          password: 'wrongpass',
        ),
      ).thenAnswer((_) async => const Result.failure('Login failed'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const LoginWithEmailRequested(
        email: 'maya@test.com',
        password: 'wrongpass',
      ),
    ),
    expect: () => [const AuthLoading(), const AuthError('Login failed')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthEmailNotVerified when register succeeds',
    setUp: () {
      when(
        () => mockRepository.registerWithEmail(
          name: 'Maya',
          email: 'maya@test.com',
          password: 'secure123',
        ),
      ).thenAnswer((_) async => Result.success(testUser));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const RegisterRequested(
        name: 'Maya',
        email: 'maya@test.com',
        password: 'secure123',
      ),
    ),
    expect: () => [const AuthLoading(), const AuthEmailNotVerified()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthVerificationEmailSent and AuthEmailNotVerified when resend succeeds',
    setUp: () {
      when(
        () => mockRepository.resendVerificationEmail(),
      ).thenAnswer((_) async => const Result.success(null));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const ResendVerificationEmailRequested()),
    expect: () => [
      const AuthVerificationEmailSent(),
      const AuthEmailNotVerified(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthError when resend verification fails',
    setUp: () {
      when(
        () => mockRepository.resendVerificationEmail(),
      ).thenAnswer((_) async => const Result.failure('Resend failed'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const ResendVerificationEmailRequested()),
    expect: () => [const AuthError('Resend failed')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthPasswordResetSent when forgot password succeeds',
    setUp: () {
      when(
        () => mockRepository.sendPasswordResetEmail(email: 'test@test.com'),
      ).thenAnswer((_) async => const Result.success(null));
    },
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const ForgotPasswordRequested(email: 'test@test.com')),
    expect: () => [const AuthLoading(), const AuthPasswordResetSent()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthAuthenticated when auth check returns verified user',
    setUp: () {
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.isEmailVerified(),
      ).thenAnswer((_) async => const Result.success(true));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthEmailNotVerified when auth check user is not verified',
    setUp: () {
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.isEmailVerified(),
      ).thenAnswer((_) async => const Result.success(false));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => [const AuthLoading(), const AuthEmailNotVerified()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthAuthenticated when Google login succeeds and verified',
    setUp: () {
      when(
        () => mockRepository.loginWithGoogle(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.isEmailVerified(),
      ).thenAnswer((_) async => const Result.success(true));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const LoginWithGoogleRequested()),
    expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthError when Google login fails',
    setUp: () {
      when(
        () => mockRepository.loginWithGoogle(),
      ).thenAnswer((_) async => const Result.failure('Google failed'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const LoginWithGoogleRequested()),
    expect: () => [const AuthLoading(), const AuthError('Google failed')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthLoading and AuthUnauthenticated when logout succeeds',
    setUp: () {
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Result.success(null));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [const AuthLoading(), const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits AuthAuthenticated when email verification check succeeds',
    setUp: () {
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.isEmailVerified(),
      ).thenAnswer((_) async => const Result.success(true));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const EmailVerificationCheckRequested()),
    expect: () => [AuthAuthenticated(testUser)],
  );
}
