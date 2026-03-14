// lib/features/settings/presentation/bloc/settings_cubit.dart
// Manages app-wide settings that persist across restarts.
// Currently handles: theme (dark/light mode).

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants.dart';

class SettingsState {
  final bool isDarkMode;
  const SettingsState({this.isDarkMode = true}); // default: dark mode
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit({required this.sharedPreferences})
      : super(const SettingsState()) {
    _loadSettings();
  }

  /// Load saved settings when app starts
  void _loadSettings() {
    final isDark =
        sharedPreferences.getBool(AppConstants.themeKey) ?? true;
    emit(SettingsState(isDarkMode: isDark));
  }

  /// Toggle between dark and light mode, and save the choice
  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await sharedPreferences.setBool(AppConstants.themeKey, newValue);
    emit(SettingsState(isDarkMode: newValue));
  }
}
