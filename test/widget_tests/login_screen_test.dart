// test/widget_tests/login_screen_test.dart
// Widget test — verifies the login screen renders and validates correctly.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/screens/login_screen.dart';

// Mock AuthBloc for testing
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Default state: unauthenticated
    when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
  });

  Widget buildLoginScreen() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen widget tests', () {
    testWidgets('renders email and password fields and login button', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      // Check that key UI elements are present
      expect(find.text('Daylight'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text("Sign-up"), findsOneWidget);
    });

    testWidgets('shows validation errors when form submitted empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      // Tap the login button without entering anything
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Validation errors should appear
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows invalid email error for bad email format', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('dispatches LoginWithEmailRequested on valid submit', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify event was added to bloc
      verify(
        () => mockAuthBloc.add(
          const LoginWithEmailRequested(
            email: 'test@test.com',
            password: 'password123',
          ),
        ),
      ).called(1);
    });

    testWidgets('shows loading indicator when AuthLoading state', (
      tester,
    ) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthLoading());
      await tester.pumpWidget(buildLoginScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
