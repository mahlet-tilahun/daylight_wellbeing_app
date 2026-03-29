// lib/features/mood/presentation/screens/add_mood_screen.dart
// Screen for logging a new mood entry.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../bloc/mood_bloc.dart';

class AddMoodScreen extends StatelessWidget {
  const AddMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pri = AppTheme.textPrimary(context);
    final sec = AppTheme.textSecondary(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Log Mood')),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How are you feeling right now?',
                  style: TextStyle(
                      color: pri, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Pick your mood',
                          style: TextStyle(
                              color: pri, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          AppConstants.moodTypes.length,
                          (i) => GestureDetector(
                            onTap: () => _logMood(
                                context, AppConstants.moodTypes[i]),
                            child: Column(
                              children: [
                                Text(AppConstants.moodEmojis[i],
                                    style: const TextStyle(fontSize: 40)),
                                const SizedBox(height: 8),
                                Text(AppConstants.moodTypes[i],
                                    style: TextStyle(color: sec, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logMood(BuildContext context, String moodType) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(
            AddMoodRequested(userId: authState.user.uid, moodType: moodType),
          );
      showSuccessSnackbar(context, '$moodType mood logged! ✓');
      Navigator.pop(context);
    }
  }
}
