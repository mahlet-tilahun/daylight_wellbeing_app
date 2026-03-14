// lib/features/helpline/presentation/pages/helpline_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/helpline_entity.dart';
import '../bloc/helpline_cubit.dart';

class HelplineScreen extends StatefulWidget {
  const HelplineScreen({super.key});
  @override
  State<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends State<HelplineScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelplineCubit>().loadHelplines();
  }

  @override
  Widget build(BuildContext context) {
    final pri = AppTheme.textPrimary(context);
    final sec = AppTheme.textSecondary(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Helpline')),
      body: BlocBuilder<HelplineCubit, HelplineState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "If you're struggling, it's okay to ask for help!\nHere are some places you can reach out:",
                  style: TextStyle(color: sec, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ...state.helplines.map((h) => _HelplineCard(helpline: h)),
                const SizedBox(height: 20),
                _ResourceButton(
                  icon: Icons.location_on_outlined,
                  label: 'Find local services',
                  onTap: () => _showComingSoon(context, 'Find local services'),
                ),
                const SizedBox(height: 10),
                _ResourceButton(
                  icon: Icons.info_outline,
                  label: 'Mental health Resources',
                  onTap: () => _showComingSoon(context, 'Mental health resources'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCallDialog(context, state.helplines),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: AppTheme.navyDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Call Helpline',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon!'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showCallDialog(BuildContext context, List<HelplineEntity> helplines) {
    final bgColor = AppTheme.isDark(context) ? AppTheme.navyCard : Colors.white;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgColor,
        title: Text('Call Helpline',
            style: TextStyle(color: AppTheme.textPrimary(context))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: helplines.map((h) => ListTile(
            leading: Text(h.flagEmoji, style: const TextStyle(fontSize: 24)),
            title: Text(h.helplineName,
                style: TextStyle(color: AppTheme.textPrimary(context))),
            subtitle: Text(h.helplineNumber,
                style: const TextStyle(color: AppTheme.accentGreen)),
            onTap: () => Navigator.pop(ctx),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppTheme.accentBlue)),
          ),
        ],
      ),
    );
  }
}

class _HelplineCard extends StatelessWidget {
  final HelplineEntity helpline;
  const _HelplineCard({required this.helpline});

  @override
  Widget build(BuildContext context) {
    final pri = AppTheme.textPrimary(context);
    final sec = AppTheme.textSecondary(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(helpline.flagEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(helpline.country,
                  style: TextStyle(color: pri, fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            const SizedBox(height: 12),
            _NumberRow(icon: Icons.phone_outlined, label: helpline.emergencyNumber,
                sublabel: 'Emergency', sec: sec),
            const SizedBox(height: 8),
            _NumberRow(icon: Icons.support_agent_outlined, label: helpline.helplineNumber,
                sublabel: helpline.helplineName, sec: sec),
          ],
        ),
      ),
    );
  }
}

class _NumberRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color sec;
  const _NumberRow({required this.icon, required this.label,
      required this.sublabel, required this.sec});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: sec, size: 18),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(
          color: AppTheme.textPrimary(context), fontWeight: FontWeight.w600)),
      const SizedBox(width: 8),
      Text(sublabel, style: TextStyle(color: sec, fontSize: 12)),
    ]);
  }
}

class _ResourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ResourceButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined, color: AppTheme.accentGreen),
        title: Text(label, style: TextStyle(color: AppTheme.textPrimary(context))),
        trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary(context)),
        onTap: onTap,
      ),
    );
  }
}
