// lib/features/mood/presentation/screens/mood_list_screen.dart
// Shows mood history as a visual chart + allows logging a new mood.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../bloc/mood_bloc.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  void _loadMoods() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(LoadMoodsRequested(authState.user.uid));
    }
  }

  void _logMood(String moodType) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(
        AddMoodRequested(userId: authState.user.uid, moodType: moodType),
      );
      showSuccessSnackbar(context, '$moodType mood logged!');
    }
  }

  void _deleteMood(String moodId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(
        DeleteMoodRequested(moodId: moodId, userId: authState.user.uid),
      );
    }
  }

  void _updateMoodNote(String moodId, String note) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<MoodBloc>().add(
        UpdateMoodNoteRequested(
          moodId: moodId,
          userId: authState.user.uid,
          note: note,
        ),
      );
    }
  }

  void _showEditNoteDialog(String moodId, String currentNote) {
    final controller = TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.navyCard,
        title: const Text('Edit Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Add a note to this mood...',
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
              _updateMoodNote(moodId, controller.text.trim());
              Navigator.pop(ctx);
              showSuccessSnackbar(context, 'Note updated!');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
        ],
      ),
      body: BlocConsumer<MoodBloc, MoodState>(
        listener: (context, state) {
          if (state is MoodError) {
            showErrorSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check in section
                _buildCheckIn(),
                const SizedBox(height: 24),

                // Mood history chart
                if (state is MoodLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is MoodLoaded) ...[
                  _buildMoodChart(state.moods),
                  const SizedBox(height: 24),
                  _buildWeekHighlights(state.moods),
                  const SizedBox(height: 24),
                  _buildMoodHistory(state.moods),
                ] else
                  const Center(
                    child: Text(
                      'Log your first mood above!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckIn() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check in With Yourself',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                AppConstants.moodTypes.length,
                (index) => GestureDetector(
                  onTap: () => _logMood(AppConstants.moodTypes[index]),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.moodEmojis[index],
                        style: const TextStyle(fontSize: 36),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.moodTypes[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChart(moods) {
    // Simple bar-style chart using Column/Row
    final days = ['mon', 'tues', 'wed', 'thu', 'fri'];
    final moodLevels = ['Great', 'Okay', 'Calm', 'Sad'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Y-axis labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: moodLevels
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            m,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 12),
                // Chart area placeholder
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: CustomPaint(painter: _MoodChartPainter(moods)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // X-axis labels
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: days
                    .map(
                      (d) => Text(
                        d,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekHighlights(moods) {
    if (moods.isEmpty) return const SizedBox.shrink();

    final mostFrequent = _getMostFrequentMood(moods);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Highlights from this week',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('☀️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'You felt $mostFrequent most often this week',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory(List moods) {
    if (moods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Moods',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...moods.take(10).map((mood) {
          final idx = AppConstants.moodTypes.indexOf(mood.moodType);
          final emoji = idx >= 0 ? AppConstants.moodEmojis[idx] : '😐';
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Text(emoji, style: const TextStyle(fontSize: 28)),
              title: Text(
                mood.moodType,
                style: TextStyle(color: AppTheme.textPrimary(context)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEE, MMM d • h:mm a').format(mood.createdAt),
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                  // Show note if present
                  if (mood.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        mood.note,
                        style: TextStyle(
                          color: AppTheme.textSecondary(context),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
              isThreeLine: mood.note.isNotEmpty,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit note button (UPDATE operation)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_note,
                      color: AppTheme.accentBlue,
                      size: 20,
                    ),
                    tooltip: 'Edit note',
                    onPressed: () =>
                        _showEditNoteDialog(mood.moodId, mood.note),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => _deleteMood(mood.moodId),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  String _getMostFrequentMood(List moods) {
    if (moods.isEmpty) return 'calm';
    final counts = <String, int>{};
    for (final m in moods) {
      counts[m.moodType] = (counts[m.moodType] ?? 0) + 1;
    }
    return counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key
        .toLowerCase();
  }
}

/// Simple custom painter for the mood chart
class _MoodChartPainter extends CustomPainter {
  final List moods;
  _MoodChartPainter(this.moods);

  @override
  void paint(Canvas canvas, Size size) {
    if (moods.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF9DFF5B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF9DFF5B)
      ..style = PaintingStyle.fill;

    final moodValues = {'Great': 0.9, 'Calm': 0.6, 'Okay': 0.4, 'Sad': 0.1};
    final recent = moods.take(5).toList().reversed.toList();
    if (recent.length < 2) return;

    final path = Path();
    for (int i = 0; i < recent.length; i++) {
      final x = (i / (recent.length - 1)) * size.width;
      final y =
          size.height - (moodValues[recent[i].moodType] ?? 0.5) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
