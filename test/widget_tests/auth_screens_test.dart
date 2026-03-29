// test/widget_tests/auth_screens_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/screens/register_screen.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/screens/forgot_password_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
    when(
      () => mockAuthBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
  });

  Widget buildRegisterScreen() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const RegisterScreen(),
      ),
    );
  }

  Widget buildForgotPasswordScreen() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const ForgotPasswordScreen(),
      ),
    );
  }

  testWidgets('RegisterScreen renders form fields and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildRegisterScreen());

    expect(find.text('Sign-Up'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('RegisterScreen shows loading indicator when AuthLoading', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(const AuthLoading());

    await tester.pumpWidget(buildRegisterScreen());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('RegisterScreen validation errors appear when submitted empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildRegisterScreen());

    await tester.tap(find.text('Sign-Up'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen renders reset form and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildForgotPasswordScreen());

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send Reset Email'), findsOneWidget);
    expect(find.text('Back to Login'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen shows error when email missing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildForgotPasswordScreen());

    await tester.tap(find.text('Send Reset Email'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
  });
}
