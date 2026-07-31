import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_buttons.dart';

// Sign Up screen — matches the "Create your account" Figma frame.
// Same pattern as LoginScreen: pure UI, calls back to the parent.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onCreateAccount,
    required this.onGoogleSignIn,
    required this.onSignIn,
    this.isLoading = false,
    this.errorMessage,
  });

  // Called with (fullName, email, password, confirmPassword)
  final void Function(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) onCreateAccount;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onSignIn;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (_formKey.currentState!.validate()) {
      widget.onCreateAccount(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _confirmPasswordController.text,
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
                  'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start your journey to global opportunities',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 22),

                AuthTextField(
                  key: const Key('fullNameField'),
                  label: 'Full name',
                  controller: _nameController,
                  hintText: 'Amara Okafor',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  key: const Key('emailField'),
                  label: 'Email address',
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
                      return 'Enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  key: const Key('confirmPasswordField'),
                  label: 'Confirm password',
                  controller: _confirmPasswordController,
                  hintText: '••••••••',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: scheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                if (widget.errorMessage != null) ...[
                  Text(
                    widget.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: scheme.error),
                  ),
                  const SizedBox(height: 12),
                ],

                PrimaryAuthButton(
                  key: const Key('createAccountButton'),
                  label: 'Create account',
                  onPressed: _handleCreateAccount,
                  isLoading: widget.isLoading,
                ),
                const SizedBox(height: 18),
                const OrDivider(),
                const SizedBox(height: 18),

                GoogleSignInButton(
                  key: const Key('googleSignInButton'),
                  onPressed: widget.onGoogleSignIn,
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    GestureDetector(
                      key: const Key('signInLink'),
                      onTap: widget.onSignIn,
                      child: Text(
                        'Sign in',
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