import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/presentation/widgets/auth_form.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('login mode shows validation errors when submitted empty',
      (tester) async {
    await tester.pumpWidget(wrap(AuthForm(
      submitLabel: 'Log in',
      onSubmit: ({required email, required password, fullName, role}) {},
    )));

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    // Login mode shouldn't show registration-only fields.
    expect(find.byKey(const Key('fullNameField')), findsNothing);
  });

  testWidgets('login mode calls onSubmit with entered credentials',
      (tester) async {
    String? capturedEmail;
    String? capturedPassword;

    await tester.pumpWidget(wrap(AuthForm(
      submitLabel: 'Log in',
      onSubmit: ({required email, required password, fullName, role}) {
        capturedEmail = email;
        capturedPassword = password;
      },
    )));

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'student@alu.education',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'Abcdef12',
    );
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(capturedEmail, 'student@alu.education');
    expect(capturedPassword, 'Abcdef12');
  });

  testWidgets(
      'register mode collects full name, role, and confirm password',
      (tester) async {
    String? capturedFullName;
    String? capturedRole;

    await tester.pumpWidget(wrap(AuthForm(
      submitLabel: 'Sign up',
      isRegistering: true,
      onSubmit: ({required email, required password, fullName, role}) {
        capturedFullName = fullName;
        capturedRole = role;
      },
    )));

    expect(find.byKey(const Key('fullNameField')), findsOneWidget);
    expect(find.byKey(const Key('roleField')), findsOneWidget);
    expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('fullNameField')),
      'Neville Iregi',
    );
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'neville@alu.education',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'Abcdef12',
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'Abcdef12',
    );
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(capturedFullName, 'Neville Iregi');
    // Defaults to 'student' since the dropdown wasn't changed.
    expect(capturedRole, 'student');
  });
}
