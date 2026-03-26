// lib/features/settings/presentation/screens/settings_screen.dart
// Settings screen: 3 user preferences (theme, display name, sound),
// all saved to SharedPreferences and restored on app restart.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Appearance ──────────────────────────────
              const _SectionHeader(title: 'Appearance'),
              Card(
                child: SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    settingsState.isDarkMode
                        ? 'Currently dark'
                        : 'Currently light',
                    style: const TextStyle(color: AppTheme.textGrey),
                  ),
                  value: settingsState.isDarkMode,
                  activeThumbColor: AppTheme.accentGreen,
                  onChanged: (_) => context.read<SettingsCubit>().toggleTheme(),
                  secondary: Icon(
                    settingsState.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Preferences ─────────────────────────────
              const _SectionHeader(title: 'Preferences'),
              Card(
                child: Column(
                  children: [
                    // Preference 2: Display name
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: AppTheme.accentBlue,
                      ),
                      title: const Text(
                        'Display Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        settingsState.displayName.isEmpty
                            ? 'Not set — tap to change'
                            : settingsState.displayName,
                        style: const TextStyle(color: AppTheme.textGrey),
                      ),
                      trailing: const Icon(
                        Icons.edit_outlined,
                        color: AppTheme.textGrey,
                        size: 18,
                      ),
                      onTap: () => _showDisplayNameDialog(
                        context,
                        settingsState.displayName,
                      ),
                    ),
                    const Divider(color: AppTheme.navyMid, height: 1),
                    // Preference 3: Relaxing sounds
                    SwitchListTile(
                      title: const Text(
                        'Relaxing Sounds',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        settingsState.soundEnabled
                            ? 'Sounds auto-play on Home'
                            : 'Sounds off by default',
                        style: const TextStyle(color: AppTheme.textGrey),
                      ),
                      value: settingsState.soundEnabled,
                      activeThumbColor: AppTheme.accentGreen,
                      onChanged: (_) =>
                          context.read<SettingsCubit>().toggleSound(),
                      secondary: const Icon(
                        Icons.music_note_outlined,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Account ──────────────────────────────────
              const _SectionHeader(title: 'Account'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'You will be returned to the login screen',
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
              const SizedBox(height: 24),

              // ── About ─────────────────────────────────────
              const _SectionHeader(title: 'About'),
              const Card(
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline,
                      label: 'App Version',
                      value: '1.0.0',
                    ),
                    Divider(color: AppTheme.navyMid, height: 1),
                    _InfoTile(
                      icon: Icons.favorite_outline,
                      label: 'Made with',
                      value: 'Flutter & Firebase',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDisplayNameDialog(BuildContext context, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.navyCard,
        title: const Text(
          'Display Name',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: AppTheme.textGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsCubit>().updateDisplayName(
                controller.text.trim(),
              );
              Navigator.pop(ctx);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.accentBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.navyCard,
        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textGrey, size: 20),
      title: Text(
        label,
        style: TextStyle(color: AppTheme.textPrimary(context)),
      ),
      trailing: Text(
        value,
        style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
      ),
    );
  }
}
