# Daylight — Mental Wellbeing App

A Flutter-based wellbeing companion app featuring authentication, mood tracking, journaling, helpline contacts, and theme settings.

## Project overview

This repository implements a cross-platform Flutter app with the following main modules:

- `lib/features/auth/` — login, registration, password reset, email verification, and auth state management.
- `lib/features/mood/` — mood tracking CRUD with mood list and add/edit flows.
- `lib/features/journal/` — journal notes CRUD with favorites support.
- `lib/features/helpline/` — helpline resources and contact actions.
- `lib/features/settings/` — theme toggle and application preferences.
- `lib/features/home/` — main shell navigation and dashboard.
- `lib/core/` — shared utilities, theme, navigation, validators, and use case abstractions.
- `lib/injection_container.dart` — dependency injection setup for application services.
- `lib/main.dart` — app entrypoint and authentication gate logic.

## Architecture

The app uses a Clean Architecture-inspired structure with:

- **Domain layer**: entities, repositories, use cases
- **Data layer**: repository implementations, models, remote/local sources
- **Presentation layer**: BLoC / Cubit state management, screens, widgets
- **Dependency injection**: `get_it`
- **State management**: `flutter_bloc`
- **Firebase integration**: Auth and Firestore support via `firebase_options.dart`

## Current feature status

### Implemented
- Authentication flows: login, register, Google sign-in, forgot password, email verification
- Mood tracking: add, list, update, delete moods
- Notes/journal: add, edit, delete, favorite notes
- Helpline screen: contact actions and resource cards
- Settings screen: theme switching and app info
- Home flow: auth gate routes between login, verification, and main shell

### Observed from current codebase
- The repository contains a complete app shell with feature modules under `lib/features`
- The app is wired with BLoC/Cubit providers in `main.dart`
- There is no explicit fake-data toggle currently visible in the source

## Testing and rubric alignment

### Test files present
- `test/auth/validators_test.dart`
- `test/auth/login_user_test.dart`
- `test/auth/auth_usecases_test.dart`
- `test/auth/auth_bloc_test.dart`
- `test/auth/auth_event_test.dart`
- `test/auth/user_entity_test.dart`
- `test/mood/mood_usecases_test.dart`
- `test/mood/mood_entity_test.dart`
- `test/widget_tests/login_screen_test.dart`
- `test/widget_tests/auth_screens_test.dart`
- `test/widget_tests/auth_form_widgets_test.dart`

### Coverage
- **Line coverage**: `81.7%`
- **Function coverage**: not available in this setup; Flutter test coverage output does not emit function-level data for `genhtml`

### Rubric alignment
- **Widget testing**: yes, widget tests are included
- **Unit tests**: yes, multiple unit tests are present across auth and mood domains
- **Coverage threshold**: yes, line coverage is above 70%
- **Screenshots**: not present in repo; add them separately to your submission PDF

## How to run the app

```bash
flutter pub get
flutter run
```

## How to run tests

```bash
flutter test
```

## How to generate coverage report

```bash
flutter test --coverage
wsl genhtml coverage/lcov.info -o coverage/html
```

> Note: The HTML report generation using `genhtml` requires WSL or another Linux-like environment. This repo currently stores line coverage only.

## Dependencies

Key dependencies in `pubspec.yaml`:

- `flutter_bloc`
- `equatable`
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `google_sign_in`
- `shared_preferences`
- `get_it`
- `intl`
- `uuid`
- `just_audio`
- `url_launcher`

## Notes for submission

- This README reflects the current file structure and implemented features.
- The project is already above the rubric coverage requirement.
- Ensure you include required screenshots in the final PDF since they are not tracked in source control.

---

> This file is a proposed README only and does not modify the existing app source code.
