// test/widget_tests/auth_form_widgets_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/widgets/auth_form.dart';

void main() {
  testWidgets('CustomButton shows text when not loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(text: 'Save', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('CustomButton shows loading indicator when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(text: 'Saving', onPressed: () {}, isLoading: true),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Saving'), findsNothing);
  });

  testWidgets('GoogleSignInButton shows icon text when idle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GoogleSignInButton(onPressed: () {})),
      ),
    );

    expect(find.text('G'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('GoogleSignInButton shows loading indicator when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoogleSignInButton(onPressed: () {}, isLoading: true),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('G'), findsNothing);
  });
}
