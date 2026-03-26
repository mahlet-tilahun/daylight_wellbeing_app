// lib/features/home/presentation/screens/main_shell.dart
// The main screen after login — holds the bottom navigation bar
// and swaps between Home, Mood, Notes, and Helpline screens.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/bottom_nav_cubit.dart';
import '../../../helpline/presentation/screens/helpline_screen.dart';
import '../../../mood/presentation/screens/mood_list_screen.dart';
import '../../../journal/presentation/screens/notes_list_screen.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  // The four main screens — order matches bottom nav tabs
  static const List<Widget> _screens = [
    HomeScreen(),
    MoodTrackerScreen(),
    NotesListScreen(),
    HelplineScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // IndexedStack keeps all screens alive (preserves scroll position etc.)
          body: IndexedStack(index: currentIndex, children: _screens),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.read<BottomNavCubit>().changeTab(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Mood',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_outlined),
                activeIcon: Icon(Icons.note),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.phone_outlined),
                activeIcon: Icon(Icons.phone),
                label: 'Helpline',
              ),
            ],
          ),
        );
      },
    );
  }
}
