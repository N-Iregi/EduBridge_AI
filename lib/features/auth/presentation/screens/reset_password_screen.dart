import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_buttons.dart';

// Reset Password screen — matches the "Reset your password" Figma frame.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.onSendResetLink,
    required this.onBackToSignIn,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final void Function(String email) onSendResetLink;
  final VoidCallback onBackToSignIn;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() {
    if (_formKey.currentState!.validate()) {
      widget.onSendResetLink(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final successColor = scheme.brightness == Brightness.dark
        ? Colors.greenAccent.shade200
        : Colors.green.shade700;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  key: const Key('backToSignInButton'),
                  onPressed: widget.onBackToSignIn,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  icon: Icon(Icons.arrow_back, size: 16, color: scheme.primary),
                  label: Text(
                    'Back to sign in',
                    style: TextStyle(fontSize: 13, color: scheme.primary),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.lock_outline,
                        color: scheme.onPrimaryContainer, size: 26),
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  'Reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the email linked to your account and we'll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 24),

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
                const SizedBox(height: 18),

                if (widget.errorMessage != null) ...[
                  Text(
                    widget.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: scheme.error),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.successMessage != null) ...[
                  Text(
                    widget.successMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: successColor),
                  ),
                  const SizedBox(height: 12),
                ],

                PrimaryAuthButton(
                  key: const Key('sendResetLinkButton'),
                  label: 'Send reset link',
                  onPressed: _handleSendLink,
                  isLoading: widget.isLoading,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't get the email? ",
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    GestureDetector(
                      key: const Key('resendLink'),
                      onTap: _handleSendLink,
                      child: Text(
                        'Resend',
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