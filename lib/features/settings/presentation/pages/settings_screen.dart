// lib/features/settings/presentation/pages/settings_screen.dart
// Settings screen: toggle dark/light mode (saved to SharedPreferences),
// and logout. Accessible via a button in HomeScreen's app bar.

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
              // ── Appearance Section ─────────────────────
              const _SectionHeader(title: 'Appearance'),
              Card(
                child: SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    settingsState.isDarkMode ? 'Currently dark' : 'Currently light',
                    style: const TextStyle(color: AppTheme.textGrey),
                  ),
                  value: settingsState.isDarkMode,
                  activeColor: AppTheme.accentGreen,
                  // Toggle saves to SharedPreferences automatically
                  onChanged: (_) =>
                      context.read<SettingsCubit>().toggleTheme(),
                  secondary: Icon(
                    settingsState.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Account Section ────────────────────────
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
                  onTap: () {
                    // Show confirmation dialog before logging out
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppTheme.navyCard,
                        title: const Text('Sign Out',
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Are you sure you want to sign out?',
                          style: TextStyle(color: AppTheme.textGrey),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel',
                                style:
                                    TextStyle(color: AppTheme.textGrey)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // close dialog
                              context
                                  .read<AuthBloc>()
                                  .add(const LogoutRequested());
                            },
                            child: const Text('Sign Out',
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ── About Section ──────────────────────────
              const _SectionHeader(title: 'About'),
              Card(
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline,
                      label: 'App Version',
                      value: '1.0.0',
                    ),
                    const Divider(color: AppTheme.navyMid, height: 1),
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
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textGrey, size: 20),
      title: Text(label, style: TextStyle(color: AppTheme.textPrimary(context))),
      trailing: Text(value,
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
    );
  }
}
