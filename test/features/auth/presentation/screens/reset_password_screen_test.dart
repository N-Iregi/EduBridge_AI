import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/presentation/screens/reset_password_screen.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('shows a validation error when submitted empty', (tester) async {
    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) {},
      onBackToSignIn: () {},
    )));

    await tester.tap(find.byKey(const Key('sendResetLinkButton')));
    await tester.pump();

    expect(find.text('Enter your email address'), findsOneWidget);
  });

  testWidgets('calls onSendResetLink with the entered email', (tester) async {
    String? capturedEmail;

    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) => capturedEmail = email,
      onBackToSignIn: () {},
    )));

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'student@alu.education',
    );
    await tester.tap(find.byKey(const Key('sendResetLinkButton')));
    await tester.pump();

    expect(capturedEmail, 'student@alu.education');
  });

  testWidgets('the resend link submits the same way as the button',
      (tester) async {
    var callCount = 0;

    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) => callCount++,
      onBackToSignIn: () {},
    )));

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'student@alu.education',
    );
    await tester.tap(find.byKey(const Key('resendLink')));
    await tester.pump();

    expect(callCount, 1);
  });

  testWidgets('calls onBackToSignIn when the back link is tapped',
      (tester) async {
    var backTapped = false;

    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) {},
      onBackToSignIn: () => backTapped = true,
    )));

    await tester.tap(find.byKey(const Key('backToSignInButton')));
    await tester.pump();

    expect(backTapped, isTrue);
  });

  testWidgets('shows the provided error and success messages', (tester) async {
    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) {},
      onBackToSignIn: () {},
      errorMessage: 'Something went wrong. Please try again.',
    )));
    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );

    await tester.pumpWidget(wrap(ResetPasswordScreen(
      onSendResetLink: (email) {},
      onBackToSignIn: () {},
      successMessage: 'Reset link sent — check your inbox.',
    )));
    expect(
      find.text('Reset link sent — check your inbox.'),
      findsOneWidget,
    );
  });
}
