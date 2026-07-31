import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../../../home/presentation/pages/dev_menu_page.dart';
import 'auth_flow_page.dart';

/// Root gate: shows the auth flow until a session is confirmed, then
/// swaps to the app's landing page.
///
/// [AuthBloc] stays in [AuthInitial] only until its `AppStarted` handler
/// resolves the cached-session lookup, so the brief spinner here is what
/// stops a returning, already-signed-in user from flashing the login
/// screen before landing on the app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // TODO: swap for the real Home Dashboard once available.
          return const DevMenuPage();
        }
        if (state is AuthUnauthenticated || state is AuthError) {
          return const AuthFlowPage();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
