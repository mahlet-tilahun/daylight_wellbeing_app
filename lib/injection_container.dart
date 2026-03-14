// lib/injection_container.dart
// Registers all app dependencies using GetIt.
// Call initDependencies() once in main() before runApp().

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'core/navigation/bottom_nav_cubit.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/login_with_google.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/helpline/data/datasources/helpline_local_datasource.dart';
import 'features/helpline/data/repositories/helpline_repository_impl.dart';
import 'features/helpline/domain/repositories/helpline_repository.dart';
import 'features/helpline/presentation/bloc/helpline_cubit.dart';
import 'features/mood/data/datasources/mood_remote_datasource.dart';
import 'features/mood/data/repositories/mood_repository_impl.dart';
import 'features/mood/domain/repositories/mood_repository.dart';
import 'features/mood/domain/usecases/mood_usecases.dart';
import 'features/mood/presentation/bloc/mood_bloc.dart';
import 'features/notes/data/datasources/notes_remote_datasource.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/domain/usecases/notes_usecases.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';

// Global service locator instance
final sl = GetIt.instance;

Future<void> initDependencies() async {

  // ── External / Third-Party ─────────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  // ── Auth ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LoginWithGoogle(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      loginWithGoogle: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
    ),
  );

  // ── Mood ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<MoodRemoteDataSource>(
    () => MoodRemoteDataSourceImpl(firestore: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => AddMood(sl()));
  sl.registerLazySingleton(() => GetMoods(sl()));
  sl.registerLazySingleton(() => DeleteMood(sl()));
  sl.registerFactory(
    () => MoodBloc(addMood: sl(), getMoods: sl(), deleteMood: sl()),
  );

  // ── Notes ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(firestore: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerFactory(
    () => NotesBloc(
      addNote: sl(),
      getNotes: sl(),
      updateNote: sl(),
      deleteNote: sl(),
      toggleFavorite: sl(),
    ),
  );

  // ── Helpline ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HelplineLocalDataSource>(
    () => HelplineLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<HelplineRepository>(
    () => HelplineRepositoryImpl(localDataSource: sl()),
  );
  sl.registerFactory(() => HelplineCubit(repository: sl()));

  // ── Core / Shared ──────────────────────────────────────────────────────────
  sl.registerFactory(() => BottomNavCubit());
  sl.registerFactory(() => SettingsCubit(sharedPreferences: sl()));
}
