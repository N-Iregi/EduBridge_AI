import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/reset_password_screen.dart';

enum _AuthView { login, signup, reset }

class AuthFlowPage extends StatelessWidget {
  const AuthFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(FirebaseAuthRepository()),
      child: const _AuthFlowView(),
    );
  }
}

class _AuthFlowView extends StatefulWidget {
  const _AuthFlowView();

  @override
  State<_AuthFlowView> createState() => _AuthFlowViewState();
}

class _AuthFlowViewState extends State<_AuthFlowView> {
  _AuthView _view = _AuthView.login;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${state.user.fullName}!')),
          );
          // TODO: navigate to the real Home Dashboard once available.
        }
        if (state is AuthPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reset link sent to ${state.email}')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final errorMessage = state is AuthError ? state.message : null;
        final bloc = context.read<AuthBloc>();

        switch (_view) {
          case _AuthView.login:
            return LoginScreen(
              isLoading: isLoading,
              errorMessage: errorMessage,
              onSignIn: (email, password, keepSignedIn) =>
                  bloc.add(SignInRequested(email, password)),
              onGoogleSignIn: () => bloc.add(const GoogleSignInRequested()),
              onForgotPassword: () => setState(() => _view = _AuthView.reset),
              onCreateAccount: () => setState(() => _view = _AuthView.signup),
            );
          case _AuthView.signup:
            return SignUpScreen(
              isLoading: isLoading,
              errorMessage: errorMessage,
              onCreateAccount: (fullName, email, password, confirmPassword) =>
                  bloc.add(SignUpRequested(fullName, email, password)),
              onGoogleSignIn: () => bloc.add(const GoogleSignInRequested()),
              onSignIn: () => setState(() => _view = _AuthView.login),
            );
          case _AuthView.reset:
            return ResetPasswordScreen(
              isLoading: isLoading,
              errorMessage: errorMessage,
              successMessage: state is AuthPasswordResetSent
                  ? 'Check your inbox for a reset link.'
                  : null,
              onSendResetLink: (email) =>
                  bloc.add(PasswordResetRequested(email)),
              onBackToSignIn: () => setState(() => _view = _AuthView.login),
            );
        }
      },
    );
  }
}