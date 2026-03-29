// lib/features/settings/data/local_datasource/shared_prefs_datasource.dart
// Local datasource for reading/writing settings via SharedPreferences.

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';

class SharedPrefsDatasource {
  final SharedPreferences _prefs;
  SharedPrefsDatasource(this._prefs);

  bool get isDarkMode => _prefs.getBool(AppConstants.themeKey) ?? true;

  Future<void> setDarkMode(bool value) =>
      _prefs.setBool(AppConstants.themeKey, value);
}
