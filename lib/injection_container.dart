// lib/injection_container.dart
// Registers all dependencies for real Firebase usage.

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
import 'features/auth/domain/usecases/auth_usecases.dart';
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
import 'features/journal/data/datasources/notes_remote_datasource.dart';
import 'features/journal/data/repositories/notes_repository_impl.dart';
import 'features/journal/domain/repositories/notes_repository.dart';
import 'features/journal/domain/usecases/notes_usecases.dart';
import 'features/journal/presentation/bloc/notes_bloc.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  // Auth
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
  sl.registerLazySingleton(() => SendPasswordReset(sl()));
  sl.registerLazySingleton(() => CheckEmailVerified(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmail(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      loginWithGoogle: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
      sendPasswordReset: sl(),
      checkEmailVerified: sl(),
      resendVerificationEmail: sl(),
    ),
  );

  // Mood
  sl.registerLazySingleton<MoodRemoteDataSource>(
    () => MoodRemoteDataSourceImpl(firestore: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => AddMood(sl()));
  sl.registerLazySingleton(() => GetMoods(sl()));
  sl.registerLazySingleton(() => DeleteMood(sl()));
  sl.registerLazySingleton(() => UpdateMoodNote(sl()));
  sl.registerFactory(
    () => MoodBloc(
      addMood: sl(),
      getMoods: sl(),
      deleteMood: sl(),
      updateMoodNote: sl(),
    ),
  );

  // Journal (Notes)
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

  // Helpline
  sl.registerLazySingleton<HelplineLocalDataSource>(
    () => HelplineLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<HelplineRepository>(
    () => HelplineRepositoryImpl(localDataSource: sl()),
  );
  sl.registerFactory(() => HelplineCubit(repository: sl()));

  // Core
  sl.registerFactory(() => BottomNavCubit());
  sl.registerFactory(() => SettingsCubit(sharedPreferences: sl()));
}
