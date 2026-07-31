import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edubridge_ai/core/services/preferences_service.dart';
import 'package:edubridge_ai/features/settings/presentation/cubit/settings_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsCubit', () {
    test('initial state reflects whatever is already persisted', () async {
      SharedPreferences.setMockInitialValues({
        'pref_theme_mode': 'dark',
        'pref_notifications_enabled': false,
        'pref_language_code': 'fr',
        'pref_biometric_login_enabled': true,
      });
      final prefs = await PreferencesService.create();
      final cubit = SettingsCubit(prefs);

      expect(cubit.state.themeMode, AppThemeMode.dark);
      expect(cubit.state.notificationsEnabled, isFalse);
      expect(cubit.state.languageCode, 'fr');
      expect(cubit.state.biometricLoginEnabled, isTrue);
    });

    test(
        'changes made through the cubit are still there for a fresh instance',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await PreferencesService.create();
      final cubit = SettingsCubit(prefs);

      await cubit.setThemeMode(AppThemeMode.dark);
      await cubit.setNotificationsEnabled(false);
      await cubit.setLanguageCode('rw');
      await cubit.setBiometricLoginEnabled(true);

      expect(cubit.state.themeMode, AppThemeMode.dark);

      // A fresh service + cubit reading the same (mocked) storage stands
      // in for the app being closed and reopened.
      final relaunchedPrefs = await PreferencesService.create();
      final relaunchedCubit = SettingsCubit(relaunchedPrefs);

      expect(relaunchedCubit.state.themeMode, AppThemeMode.dark);
      expect(relaunchedCubit.state.notificationsEnabled, isFalse);
      expect(relaunchedCubit.state.languageCode, 'rw');
      expect(relaunchedCubit.state.biometricLoginEnabled, isTrue);
    });
  });
}
