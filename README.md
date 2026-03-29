# Daylight 🌅

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)](https://dart.dev)

**Daylight** is a cross-platform mental wellbeing companion app built with Flutter, following Clean Architecture principles and BLoC state management. Track your mood, journal thoughts, access helplines, and more—all with light/dark theme support.



## ✨ Features

- **Authentication**: Secure login and registration with Firebase Auth.
- **Mood Tracking**: Log, view, edit, and delete daily moods with CRUD operations.
- **Journal/Notes**: Private notes for reflections and wellbeing journal.
- **Helpline Contacts**: Quick access to support helplines.
- **Home Dashboard**: Personalized overview of your wellbeing journey.
- **Settings**: Customize theme (light/dark mode).
- **Fake Data Mode**: Run fully without Firebase for development.
- **Cross-Platform**: Android, iOS, Web, Desktop (Windows/macOS/Linux).



## 🚀 Quick Start (Fake Data Mode — No Firebase Needed)

1. Clone the repo and navigate to the project directory.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

The app defaults to `useFakeData = true` in `lib/main.dart`, providing in-memory data for full UI testing without backend setup.

## 🔧 Full Firebase Setup

1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
2. Run `flutterfire configure` in the project root to generate `firebase_options.dart`.
3. In `lib/main.dart`:
   - Set `useFakeData = false`
   - Ensure Firebase init is uncommented (already present).
4. Update Firebase console with your Android/iOS bundle IDs and SHA-1.
5. Run `flutter pub get && flutter run`.

## 🛠️ Tech Stack

| Category                 | Technologies                                      |
| ------------------------ | ------------------------------------------------- |
| **Framework**            | Flutter (3.x), Dart (3.x)                         |
| **State Management**     | flutter_bloc, equatable                           |
| **Architecture**         | Clean Architecture                                |
| **Backend/Storage**      | Firebase Auth, Cloud Firestore, SharedPreferences |
| **Dependency Injection** | get_it                                            |
| **Testing**              | flutter_test (unit/widget tests)                  |
| **Platforms**            | Android, iOS, Web, Linux, macOS, Windows          |



## 🏗️ Architecture

Daylight uses **Clean Architecture** with **BLoC pattern** for separation of concerns:

```
lib/
├── core/              # Shared: error, usecases, utils, theme, navigation
├── features/
│   ├── auth/          # Login, Register
│   ├── home/          # Dashboard
│   ├── mood/          # Mood tracking CRUD
│   ├── notes/         # Notes/Journal CRUD
│   ├── helpline/      # Helpline contacts
│   └── settings/      # Theme toggle
├── injection_container.dart     # Real Firebase DI
├── injection_container_fake.dart # Fake/test DI
└── main.dart
```

Each feature follows: `data/` → `domain/` → `presentation/`

- **Domain Layer**: Pure business logic, entities, usecases.
- **Data Layer**: Repositories, remote/local datasources.
- **Presentation Layer**: BLoC/Cubit + UI.

Dependency Injection via `get_it`. State management: `flutter_bloc`.

## 📁 Project Structure

```
lib/
├── core/                 # Source code shared utilities
├── features/             # Feature-specific modules
├── android/, ios/, etc.  # Platform configs
├── pubspec.yaml          # Dependencies
├── test/                 # Tests
└── README.md             # Documentation
```

## 🧪 Running Tests

```bash
flutter test
```

Includes unit tests (auth validators, mood usecases) and widget tests (login screen).

## 🚀 Building for Release

- **Android APK**:
  ```bash
  flutter build apk --release
  ```
- **iOS**:
  ```bash
  flutter build ios --release
  ```
- **Web**:
  ```bash
  flutter build web
  ```
- **Windows**:
  ```bash
  flutter build windows --release
  ```

Pro tip: Use `--obfuscate --split-debug-info=build/debug-info` for production.

## 👥 Team

| Team Member       | Role                                              |
| ----------------- | ------------------------------------------------- |
| Solace Aziza Afadhali | All UI screens and widgets                        |
| Mahlet Assefa Tilahun | Domain layer (entities, repos, usecases) + BLoC   |
| Divine Okon Itu | Firebase setup, Firestore repositories            |
| Olive Umurerwa  | BLoC integration, CRUD operations, error handling |
| Agertu Diriba Aliko   | Tests, documentation, demo preparation            |

