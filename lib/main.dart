import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/preferences_service.dart';
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/pages/dev_menu_page.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferencesService = await PreferencesService.create();
  runApp(MyApp(preferencesService: preferencesService));
}

/// Root widget: sets up the [MaterialApp] and its theme.
///
/// [AuthBloc] and [SettingsCubit] are provided here, above [MaterialApp],
/// rather than by whichever page happens to need them — they have to
/// outlive any single screen so that signing in (or changing a setting)
/// is still visible once you've navigated back to the dev menu or any
/// other screen. [SettingsCubit]'s theme mode is read right here too,
/// which is what makes a persisted theme choice actually change how the
/// app looks after a restart, rather than just sitting in storage unused.
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.preferencesService});

  final PreferencesService preferencesService;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(FirebaseAuthRepository())),
        BlocProvider(create: (_) => SettingsCubit(preferencesService)),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<SettingsCubit>().state.themeMode;
          return MaterialApp(
            title: 'EduBridge AI',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: switch (themeMode) {
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
              AppThemeMode.system => ThemeMode.system,
            },
            home: const DevMenuPage(),
          );
        },
      ),
    );
  }
}