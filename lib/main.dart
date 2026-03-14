// lib/main.dart
// App entry point. Initializes Firebase then runs the app.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/navigation/bottom_nav_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/helpline/presentation/bloc/helpline_cubit.dart';
import 'features/home/presentation/pages/main_shell.dart';
import 'features/mood/presentation/bloc/mood_bloc.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options
  // Run: flutterfire configure  to generate firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register all dependencies
  await initDependencies();

  runApp(const DaylightApp());
}

class DaylightApp extends StatelessWidget {
  const DaylightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => sl<SettingsCubit>(),
        ),
        BlocProvider<BottomNavCubit>(
          create: (_) => sl<BottomNavCubit>(),
        ),
        BlocProvider<MoodBloc>(
          create: (_) => sl<MoodBloc>(),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => sl<NotesBloc>(),
        ),
        BlocProvider<HelplineCubit>(
          create: (_) => sl<HelplineCubit>(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Daylight',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const _AuthGate(),
          );
        },
      ),
    );
  }
}

/// Routes to login or home based on whether the user is signed in.
/// This is the auth guard — unauthenticated users cannot reach home.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show splash while checking auth status
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny, size: 60, color: Color(0xFFFFD700)),
                  SizedBox(height: 16),
                  Text(
                    'Daylight',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4FC3F7),
                    ),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        if (state is AuthAuthenticated) return const MainShell();
        return const LoginScreen();
      },
    );
  }
}
