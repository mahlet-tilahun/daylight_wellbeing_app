# Daylight – Mental Wellbeing App

A Flutter app built with Clean Architecture, BLoC state management, and Firebase.

---

## Running the App (Fake Data Mode — No Firebase needed)

```bash
flutter pub get
flutter run
```

`useFakeData = true` is set in `main.dart` by default. The app runs fully with in-memory fake data — no Firebase setup required for UI development.

---

## Switching to Real Firebase

1. Complete Firebase setup (Person 3 – Divine's task)
2. In `main.dart`, set `useFakeData = false`
3. Uncomment the Firebase initialization block in `main.dart`

---

## Branch Strategy

| Person | Name | Branch |
|--------|------|--------|
| Person 1 | Solace | `solace-ui` |
| Person 2 | Mahlet | `mahlet-bloc` |
| Person 3 | Divine | `divine-firebase` |
| Person 4 | Olive | `olive-integration` |
| Person 5 | Maya | `maya-docs` |

```bash
# Create and switch to your branch
git checkout -b your-branch-name

# Push your branch
git push origin your-branch-name
```

---

## Architecture

```
lib/
├── core/              # Shared: error, usecases, utils, theme, navigation
├── features/
│   ├── auth/          # Login, Register
│   ├── home/          # Dashboard
│   ├── mood/          # Mood tracking CRUD
│   ├── journal/       # Notes/Journal CRUD
│   ├── helpline/      # Helpline contacts
│   └── settings/      # Theme toggle
├── injection_container.dart       # Real Firebase DI
├── injection_container_fake.dart  # Fake/test DI
└── main.dart
```

Each feature follows: `data/` → `domain/` → `presentation/`

---

## Team Task Summary

- **Solace**: All UI screens and widgets
- **Mahlet**: Domain layer (entities, repos, usecases) + BLoC
- **Divine**: Firebase setup, Firestore, repository implementations
- **Olive**: Wiring BLoC ↔ usecases ↔ repositories, CRUD, error handling
- **Maya**: Tests, documentation, Git monitoring, demo prep
