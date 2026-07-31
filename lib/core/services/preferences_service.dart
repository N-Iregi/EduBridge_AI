import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

/// Wraps SharedPreferences so the rest of the app never touches raw
/// string keys. Four settings are persisted and restored on relaunch:
/// theme mode, notifications toggle, language code, and biometric login.
class PreferencesService {
  PreferencesService(this._prefs);

  static const _kThemeMode = 'pref_theme_mode';
  static const _kNotificationsEnabled = 'pref_notifications_enabled';
  static const _kLanguageCode = 'pref_language_code';
  static const _kBiometricLoginEnabled = 'pref_biometric_login_enabled';

  final SharedPreferences _prefs;

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  AppThemeMode get themeMode {
    final raw = _prefs.getString(_kThemeMode);
    return AppThemeMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode.name);

  bool get notificationsEnabled =>
      _prefs.getBool(_kNotificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_kNotificationsEnabled, value);

  String get languageCode => _prefs.getString(_kLanguageCode) ?? 'en';

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_kLanguageCode, code);

  bool get biometricLoginEnabled =>
      _prefs.getBool(_kBiometricLoginEnabled) ?? false;

  Future<void> setBiometricLoginEnabled(bool value) =>
      _prefs.setBool(_kBiometricLoginEnabled, value);
}
