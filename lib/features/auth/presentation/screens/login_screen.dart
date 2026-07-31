import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_buttons.dart';

// Login screen — matches the "Welcome back" Figma frame.
// Just collects input and calls back to the parent, so it doesn't
// care what state management the team ends up using.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onSignIn,
    required this.onGoogleSignIn,
    required this.onForgotPassword,
    required this.onCreateAccount,
    this.isLoading = false,
    this.errorMessage,
  });

  final void Function(String email, String password, bool keepSignedIn)
      onSignIn;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _keepSignedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      widget.onSignIn(
        _emailController.text.trim(),
        _passwordController.text,
        _keepSignedIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.school, color: scheme.onPrimary, size: 28),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'EduBridge',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please enter your details to sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                GoogleSignInButton(
                  key: const Key('googleSignInButton'),
                  onPressed: widget.onGoogleSignIn,
                ),
                const SizedBox(height: 18),
                const OrDivider(),
                const SizedBox(height: 18),

                AuthTextField(
                  key: const Key('emailField'),
                  label: 'Email Address',
                  controller: _emailController,
                  hintText: 'student@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email address';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  key: const Key('passwordField'),
                  label: 'Password',
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: scheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const Key('forgotPasswordButton'),
                    onPressed: widget.onForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        key: const Key('keepSignedInCheckbox'),
                        value: _keepSignedIn,
                        activeColor: scheme.primary,
                        onChanged: (value) {
                          setState(() => _keepSignedIn = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Keep me signed in for 30 days',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (widget.errorMessage != null) ...[
                  Text(
                    widget.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: scheme.error),
                  ),
                  const SizedBox(height: 12),
                ],

                PrimaryAuthButton(
                  key: const Key('signInButton'),
                  label: 'Sign In',
                  onPressed: _handleSignIn,
                  isLoading: widget.isLoading,
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    GestureDetector(
                      key: const Key('createAccountLink'),
                      onTap: widget.onCreateAccount,
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}