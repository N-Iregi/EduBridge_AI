import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: widget.onBackToSignIn,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.primaryBlue),
                  label: const Text(
                    'Back to sign in',
                    style: TextStyle(fontSize: 13, color: AppColors.primaryBlue),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.infoBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: AppColors.primaryBlue, size: 26),
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter the email linked to your account and we'll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 24),

                AuthTextField(
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
                    style: const TextStyle(fontSize: 12, color: AppColors.danger),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.successMessage != null) ...[
                  Text(
                    widget.successMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColors.success),
                  ),
                  const SizedBox(height: 12),
                ],

                PrimaryAuthButton(
                  label: 'Send reset link',
                  onPressed: _handleSendLink,
                  isLoading: widget.isLoading,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't get the email? ",
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: _handleSendLink,
                      child: const Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryBlue,
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