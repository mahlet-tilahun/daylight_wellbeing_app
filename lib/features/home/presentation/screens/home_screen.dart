// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../mood/presentation/bloc/mood_bloc.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../../../settings/presentation/bloc/settings_cubit.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AudioPlayer instance — one player, swapped per sound
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingSound;
  int _tipIndex = 0;

  final List<Map<String, String>> _wellbeingTips = [
    {'title': 'Breath', 'body': 'Pause for 3 slow breaths before starting a task.'},
    {'title': 'Move',   'body': 'Take a 5-minute walk to reset your focus.'},
    {'title': 'Hydrate','body': 'Drink a glass of water — your brain needs it.'},
  ];

  // Map each sound name to its asset file path
  final List<Map<String, String>> _sounds = [
    {'name': 'Sleeping', 'duration': '2-5 minutes to unwind', 'asset': 'assets/sounds/sleeping.mp3'},
    {'name': 'Rain',     'duration': '5-10 minutes of calm',  'asset': 'assets/sounds/rain.mp3'},
    {'name': 'Forest',   'duration': '3-8 minutes of nature', 'asset': 'assets/sounds/forest.mp3'},
  ];

  @override
  void dispose() {
    // Always release the audio player when the screen is removed
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Toggle a sound on or off.
  /// If a different sound is already playing, stop it first, then start the new one.
  Future<void> _toggleSound(String name, String assetPath) async {
    if (_playingSound == name) {
      // Same sound tapped — stop it
      await _audioPlayer.stop();
      setState(() => _playingSound = null);
    } else {
      // Different sound tapped — stop current, load and loop new one
      await _audioPlayer.stop();
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setLoopMode(LoopMode.one); // loop until manually stopped
      await _audioPlayer.play();
      setState(() => _playingSound = name);
    }
  }

  void _logMood(String moodType) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(
            AddMoodRequested(userId: authState.user.uid, moodType: moodType));
      showSuccessSnackbar(context, '$moodType mood logged! ✓');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pri = AppTheme.textPrimary(context);
    final sec = AppTheme.textSecondary(context);
    final dark = AppTheme.isDark(context);

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final authName = authState is AuthAuthenticated
              ? authState.user.name : 'Friend';
          // Prefer saved display name from settings, fall back to auth name
          final settingsState = context.read<SettingsCubit>().state;
          final userName = settingsState.displayName.isNotEmpty
              ? settingsState.displayName
              : authName;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(userName, pri, sec),
                  const SizedBox(height: 20),
                  Text('How are you feeling today?',
                      style: TextStyle(color: pri, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildMoodCheckIn(pri, sec),
                  const SizedBox(height: 20),
                  _buildWellbeingTips(pri, sec, dark),
                  const SizedBox(height: 20),
                  _buildRelaxingSounds(pri, sec, dark),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(String userName, Color pri, Color sec) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
          ),
          child: const Icon(Icons.wb_sunny, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Text('Daylight',
            style: TextStyle(
              color: AppTheme.isDark(context) ? AppTheme.accentBlue : AppTheme.lightPrimary,
              fontWeight: FontWeight.bold, fontSize: 18)),
        const Spacer(),
        Text('Good Morning $userName', style: TextStyle(color: sec, fontSize: 12)),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: sec, size: 22),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
        IconButton(
          icon: Icon(Icons.power_settings_new, color: sec, size: 22),
          onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
        ),
      ],
    );
  }

  Widget _buildMoodCheckIn(Color pri, Color sec) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check in With Yourself',
                style: TextStyle(color: pri, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(AppConstants.moodTypes.length, (i) =>
                GestureDetector(
                  onTap: () => _logMood(AppConstants.moodTypes[i]),
                  child: Column(children: [
                    Text(AppConstants.moodEmojis[i], style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 4),
                    Text(AppConstants.moodTypes[i], style: TextStyle(color: sec, fontSize: 12)),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWellbeingTips(Color pri, Color sec, bool dark) {
    final tip = _wellbeingTips[_tipIndex];
    final dotActive = dark ? AppTheme.accentGreen : AppTheme.lightPrimary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('✳️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text('Well-being Tips', style: TextStyle(color: pri, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            Text(tip['title']!, style: TextStyle(color: pri, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(tip['body']!, style: TextStyle(color: sec, fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_wellbeingTips.length, (i) =>
                GestureDetector(
                  onTap: () => setState(() => _tipIndex = i), // local UI carousel state — no business logic
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _tipIndex == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _tipIndex == i ? dotActive : sec.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaxingSounds(Color pri, Color sec, bool dark) {
    final toggleActive = dark ? AppTheme.accentGreen : AppTheme.lightPrimary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('🎵', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text('Relaxing Sounds', style: TextStyle(color: pri, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            ..._sounds.map((sound) {
              final isPlaying = _playingSound == sound['name'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sound['name']!,
                              style: TextStyle(color: pri, fontWeight: FontWeight.bold)),
                          Text(sound['duration']!, style: TextStyle(color: sec, fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleSound(
                        sound['name']!,
                        sound['asset']!,
                      ),
                      child: Container(
                        width: 36, height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isPlaying ? toggleActive : sec.withOpacity(0.2),
                          border: Border.all(color: sec.withOpacity(0.4)),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: isPlaying ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 16, height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
