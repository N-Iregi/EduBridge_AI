import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/presentation/screens/signup_screen.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('shows validation errors when submitted empty', (tester) async {
    await tester.pumpWidget(wrap(SignUpScreen(
      onCreateAccount: (fullName, email, password, confirmPassword) {},
      onGoogleSignIn: () {},
      onSignIn: () {},
    )));

    await tester.tap(find.byKey(const Key('createAccountButton')));
    await tester.pump();

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Enter a password'), findsOneWidget);
    // Confirm password is empty too, but that matches the (also empty)
    // password field, so it shouldn't raise a mismatch error on its own.
    expect(find.text('Passwords do not match'), findsNothing);
  });

  testWidgets('calls onCreateAccount with the entered details', (tester) async {
    String? capturedFullName;
    String? capturedEmail;
    String? capturedPassword;
    String? capturedConfirmPassword;

    await tester.pumpWidget(wrap(SignUpScreen(
      onCreateAccount: (fullName, email, password, confirmPassword) {
        capturedFullName = fullName;
        capturedEmail = email;
        capturedPassword = password;
        capturedConfirmPassword = confirmPassword;
      },
      onGoogleSignIn: () {},
      onSignIn: () {},
    )));

    await tester.enterText(
      find.byKey(const Key('fullNameField')),
      'Amara Okafor',
    );
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'amara@alu.education',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'Abcdef12',
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'Abcdef12',
    );
    await tester.tap(find.byKey(const Key('createAccountButton')));
    await tester.pump();

    expect(capturedFullName, 'Amara Okafor');
    expect(capturedEmail, 'amara@alu.education');
    expect(capturedPassword, 'Abcdef12');
    expect(capturedConfirmPassword, 'Abcdef12');
  });

  testWidgets('shows a mismatch error when the passwords differ, and does not submit',
      (tester) async {
    var submitted = false;

    await tester.pumpWidget(wrap(SignUpScreen(
      onCreateAccount: (fullName, email, password, confirmPassword) {
        submitted = true;
      },
      onGoogleSignIn: () {},
      onSignIn: () {},
    )));

    await tester.enterText(
      find.byKey(const Key('fullNameField')),
      'Amara Okafor',
    );
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'amara@alu.education',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'Abcdef12',
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'Different1',
    );
    await tester.tap(find.byKey(const Key('createAccountButton')));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(submitted, isFalse);
  });

  testWidgets('calls onGoogleSignIn and onSignIn from their controls',
      (tester) async {
    var googleTapped = false;
    var signInTapped = false;

    await tester.pumpWidget(wrap(SignUpScreen(
      onCreateAccount: (fullName, email, password, confirmPassword) {},
      onGoogleSignIn: () => googleTapped = true,
      onSignIn: () => signInTapped = true,
    )));

    await tester.ensureVisible(find.byKey(const Key('googleSignInButton')));
    await tester.tap(find.byKey(const Key('googleSignInButton')));
    await tester.ensureVisible(find.byKey(const Key('signInLink')));
    await tester.tap(find.byKey(const Key('signInLink')));
    await tester.pump();

    expect(googleTapped, isTrue);
    expect(signInTapped, isTrue);
  });

  testWidgets('shows the provided error message', (tester) async {
    await tester.pumpWidget(wrap(SignUpScreen(
      onCreateAccount: (fullName, email, password, confirmPassword) {},
      onGoogleSignIn: () {},
      onSignIn: () {},
      errorMessage: 'An account already exists with that email.',
    )));

    expect(
      find.text('An account already exists with that email.'),
      findsOneWidget,
    );
  });
}
