// test/auth/auth_event_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:daylight_wellbeing_app/features/auth/presentation/bloc/auth_event.dart';

void main() {
  test('Auth events compare props correctly', () {
    expect(const AuthCheckRequested(), const AuthCheckRequested());
    expect(
      const LoginWithEmailRequested(email: 'a@a.com', password: 'pass'),
      const LoginWithEmailRequested(email: 'a@a.com', password: 'pass'),
    );
    expect(const LoginWithGoogleRequested(), const LoginWithGoogleRequested());
    expect(
      const RegisterRequested(
        name: 'Maya',
        email: 'm@t.com',
        password: 'abc123',
      ),
      const RegisterRequested(
        name: 'Maya',
        email: 'm@t.com',
        password: 'abc123',
      ),
    );
    expect(const LogoutRequested(), const LogoutRequested());
    expect(
      const ForgotPasswordRequested(email: 'test@test.com'),
      const ForgotPasswordRequested(email: 'test@test.com'),
    );
    expect(
      const EmailVerificationCheckRequested(),
      const EmailVerificationCheckRequested(),
    );
    expect(
      const ResendVerificationEmailRequested(),
      const ResendVerificationEmailRequested(),
    );
  });
}
