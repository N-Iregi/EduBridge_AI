import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/preferences_service.dart';
import '../cubit/settings_cubit.dart';

const _languages = [
  ('en', 'English'),
  ('fr', 'Français'),
  ('rw', 'Kinyarwanda'),
];

/// Reads the [SettingsCubit] provided at the app root (see main.dart) —
/// same reasoning as AuthFlowPage reading the shared AuthBloc: a change
/// made here has to be visible everywhere else immediately, not just
/// within this page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Theme', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<AppThemeMode>(
            segments: const [
              ButtonSegment(
                value: AppThemeMode.system,
                label: Text('System'),
              ),
              ButtonSegment(value: AppThemeMode.light, label: Text('Light')),
              ButtonSegment(value: AppThemeMode.dark, label: Text('Dark')),
            ],
            selected: {state.themeMode},
            onSelectionChanged: (selection) =>
                cubit.setThemeMode(selection.first),
          ),
          const Divider(height: 32),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notifications'),
            subtitle: const Text('Deadline reminders and app updates'),
            value: state.notificationsEnabled,
            onChanged: cubit.setNotificationsEnabled,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Biometric login'),
            subtitle: const Text('Use Face/Touch ID to sign in'),
            value: state.biometricLoginEnabled,
            onChanged: cubit.setBiometricLoginEnabled,
          ),
          const Divider(height: 32),
          Text('Language', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: state.languageCode,
            isExpanded: true,
            items: [
              for (final (code, label) in _languages)
                DropdownMenuItem(value: code, child: Text(label)),
            ],
            onChanged: (value) {
              if (value != null) cubit.setLanguageCode(value);
            },
          ),
        ],
      ),
    );
  }
}
