import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once when [AuthBloc] is created, to check whether Firebase
/// already has a cached session before any button is pressed — this is
/// what makes "signed in across a cold restart" show up as an [AuthState]
/// at all.
class AppStarted extends AuthEvent {
  const AppStarted();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  const SignUpRequested(this.fullName, this.email, this.password);
  @override
  List<Object?> get props => [fullName, email, password];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class PasswordResetRequested extends AuthEvent {
  final String email;
  const PasswordResetRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}