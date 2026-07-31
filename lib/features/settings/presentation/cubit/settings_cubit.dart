import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/preferences_service.dart';

/// Snapshot of everything [PreferencesService] persists, so screens have
/// one object to read instead of four separate getters.
class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.notificationsEnabled,
    required this.languageCode,
    required this.biometricLoginEnabled,
  });

  final AppThemeMode themeMode;
  final bool notificationsEnabled;
  final String languageCode;
  final bool biometricLoginEnabled;

  SettingsState copyWith({
    AppThemeMode? themeMode,
    bool? notificationsEnabled,
    String? languageCode,
    bool? biometricLoginEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      languageCode: languageCode ?? this.languageCode,
      biometricLoginEnabled:
          biometricLoginEnabled ?? this.biometricLoginEnabled,
    );
  }
}

/// Unlike career/cv_builder/essay_assistant/deadline_tracker's Cubits,
/// this one isn't in-memory only — every setter writes through
/// [PreferencesService] first, so a change made here is still there after
/// a cold restart, not just for the rest of this session.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs)
      : super(SettingsState(
          themeMode: _prefs.themeMode,
          notificationsEnabled: _prefs.notificationsEnabled,
          languageCode: _prefs.languageCode,
          biometricLoginEnabled: _prefs.biometricLoginEnabled,
        ));

  final PreferencesService _prefs;

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setNotificationsEnabled(value);
    emit(state.copyWith(notificationsEnabled: value));
  }

  Future<void> setLanguageCode(String code) async {
    await _prefs.setLanguageCode(code);
    emit(state.copyWith(languageCode: code));
  }

  Future<void> setBiometricLoginEnabled(bool value) async {
    await _prefs.setBiometricLoginEnabled(value);
    emit(state.copyWith(biometricLoginEnabled: value));
  }
}
