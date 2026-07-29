import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edubridge_ai/core/services/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService', () {
    test('defaults to system theme and notifications on', () async {
      SharedPreferences.setMockInitialValues({});
      final service = await PreferencesService.create();

      expect(service.themeMode, AppThemeMode.system);
      expect(service.notificationsEnabled, isTrue);
      expect(service.languageCode, 'en');
      expect(service.biometricLoginEnabled, isFalse);
    });

    test('persists updated settings across a simulated relaunch', () async {
      SharedPreferences.setMockInitialValues({});
      final service = await PreferencesService.create();

      await service.setThemeMode(AppThemeMode.dark);
      await service.setNotificationsEnabled(false);
      await service.setLanguageCode('fr');
      await service.setBiometricLoginEnabled(true);

      // A fresh instance reading the same (mocked) storage stands in
      // for the app being closed and reopened.
      final relaunched = await PreferencesService.create();

      expect(relaunched.themeMode, AppThemeMode.dark);
      expect(relaunched.notificationsEnabled, isFalse);
      expect(relaunched.languageCode, 'fr');
      expect(relaunched.biometricLoginEnabled, isTrue);
    });
  });
}
