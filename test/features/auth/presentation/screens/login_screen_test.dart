import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/presentation/screens/login_screen.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('shows validation errors when submitted empty', (tester) async {
    await tester.pumpWidget(wrap(LoginScreen(
      onSignIn: (email, password, keepSignedIn) {},
      onGoogleSignIn: () {},
      onForgotPassword: () {},
      onCreateAccount: () {},
    )));

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets(
      'calls onSignIn with the entered credentials and the keep-signed-in flag',
      (tester) async {
    String? capturedEmail;
    String? capturedPassword;
    bool? capturedKeepSignedIn;

    await tester.pumpWidget(wrap(LoginScreen(
      onSignIn: (email, password, keepSignedIn) {
        capturedEmail = email;
        capturedPassword = password;
        capturedKeepSignedIn = keepSignedIn;
      },
      onGoogleSignIn: () {},
      onForgotPassword: () {},
      onCreateAccount: () {},
    )));

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'student@alu.education',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'Abcdef12',
    );
    await tester.tap(find.byKey(const Key('keepSignedInCheckbox')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(capturedEmail, 'student@alu.education');
    expect(capturedPassword, 'Abcdef12');
    expect(capturedKeepSignedIn, isTrue);
  });

  testWidgets('calls onGoogleSignIn when the Google button is tapped',
      (tester) async {
    var googleTapped = false;

    await tester.pumpWidget(wrap(LoginScreen(
      onSignIn: (email, password, keepSignedIn) {},
      onGoogleSignIn: () => googleTapped = true,
      onForgotPassword: () {},
      onCreateAccount: () {},
    )));

    await tester.tap(find.byKey(const Key('googleSignInButton')));
    await tester.pump();

    expect(googleTapped, isTrue);
  });

  testWidgets('calls onForgotPassword and onCreateAccount from their links',
      (tester) async {
    var forgotTapped = false;
    var createTapped = false;

    await tester.pumpWidget(wrap(LoginScreen(
      onSignIn: (email, password, keepSignedIn) {},
      onGoogleSignIn: () {},
      onForgotPassword: () => forgotTapped = true,
      onCreateAccount: () => createTapped = true,
    )));

    await tester.tap(find.byKey(const Key('forgotPasswordButton')));
    await tester.ensureVisible(find.byKey(const Key('createAccountLink')));
    await tester.tap(find.byKey(const Key('createAccountLink')));
    await tester.pump();

    expect(forgotTapped, isTrue);
    expect(createTapped, isTrue);
  });

  testWidgets('shows the provided error message', (tester) async {
    await tester.pumpWidget(wrap(LoginScreen(
      onSignIn: (email, password, keepSignedIn) {},
      onGoogleSignIn: () {},
      onForgotPassword: () {},
      onCreateAccount: () {},
      errorMessage: 'Incorrect email or password.',
    )));

    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });
}
