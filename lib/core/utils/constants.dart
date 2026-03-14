// lib/core/utils/constants.dart
// App-wide constants used across features.

class AppConstants {
  AppConstants._(); // prevent instantiation

  // Firebase Collection Names — must match ERD exactly
  static const String usersCollection = 'users';
  static const String moodsCollection = 'moods';
  static const String notesCollection = 'notes';
  static const String helplinesCollection = 'helplines';

  // SharedPreferences Keys
  static const String themeKey = 'is_dark_mode';
  static const String onboardingKey = 'has_seen_onboarding';

  // Mood Types
  static const List<String> moodTypes = ['Great', 'Calm', 'Okay', 'Sad'];

  // Mood Emojis — index matches moodTypes
  static const List<String> moodEmojis = ['😄', '😊', '😐', '😢'];
}
