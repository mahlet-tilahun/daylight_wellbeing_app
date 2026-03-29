// lib/features/settings/presentation/bloc/settings_cubit.dart
// Manages app-wide settings persisted in SharedPreferences.
// Preferences:
//   1. isDarkMode     — dark/light theme toggle
//   2. displayName    — user's preferred display name in greetings
//   3. soundEnabled   — whether relaxing sounds are on by default

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final String displayName;
  final bool soundEnabled;

  const SettingsState({
    this.isDarkMode = true,
    this.displayName = '',
    this.soundEnabled = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? displayName,
    bool? soundEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      displayName: displayName ?? this.displayName,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  List<Object> get props => [isDarkMode, displayName, soundEnabled];
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit({required this.sharedPreferences})
      : super(const SettingsState()) {
    _loadSettings();
  }

  /// Load all saved settings when app starts
  void _loadSettings() {
    final isDark = sharedPreferences.getBool(AppConstants.themeKey) ?? true;
    final name = sharedPreferences.getString(AppConstants.displayNameKey) ?? '';
    final sound = sharedPreferences.getBool(AppConstants.soundEnabledKey) ?? false;
    emit(SettingsState(isDarkMode: isDark, displayName: name, soundEnabled: sound));
  }

  /// Toggle dark/light mode and persist
  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await sharedPreferences.setBool(AppConstants.themeKey, newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  /// Update display name and persist
  Future<void> updateDisplayName(String name) async {
    await sharedPreferences.setString(AppConstants.displayNameKey, name);
    emit(state.copyWith(displayName: name));
  }

  /// Toggle sound preference and persist
  Future<void> toggleSound() async {
    final newValue = !state.soundEnabled;
    await sharedPreferences.setBool(AppConstants.soundEnabledKey, newValue);
    emit(state.copyWith(soundEnabled: newValue));
  }
}
