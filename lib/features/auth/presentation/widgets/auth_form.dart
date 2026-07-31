import 'package:flutter/material.dart';

import 'package:edubridge_ai/core/validators.dart';

/// Reusable email/password form used by both the login and register
/// screens. UI-only — validation and submission wiring live here so
/// Person 1/2 can drop this straight into their screens and just
/// supply an [onSubmit] callback.
///
/// In registration mode it also collects [fullName] and [role], since
/// the users/{uid} Firestore document (per the ERD) requires both at
/// account creation.
class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.isRegistering = false,
  });

  final String submitLabel;
  final bool isRegistering;
  final void Function({
    required String email,
    required String password,
    String? fullName,
    String? role,
  }) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _role = 'student';
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: widget.isRegistering ? _fullNameController.text.trim() : null,
        role: widget.isRegistering ? _role : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isRegistering) ...[
            TextFormField(
              key: const Key('fullNameField'),
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: const Key('roleField'),
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'I am a...'),
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Student')),
                DropdownMenuItem(value: 'mentor', child: Text('Mentor')),
              ],
              onChanged: (value) => setState(() => _role = value ?? 'student'),
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            key: const Key('emailField'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validators.email,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('passwordField'),
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: Validators.password,
          ),
          if (widget.isRegistering) ...[
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('confirmPasswordField'),
              controller: _confirmController,
              obscureText: _obscure,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              validator: (v) =>
                  Validators.confirmPassword(v, _passwordController.text),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            key: const Key('submitButton'),
            onPressed: _submit,
            child: Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
