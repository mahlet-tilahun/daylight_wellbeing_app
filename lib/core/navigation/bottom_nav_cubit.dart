// lib/core/navigation/bottom_nav_cubit.dart
// Manages which tab is selected in the bottom navigation bar.
// Simple cubit — just holds an index.

import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // starts on Home tab (index 0)

  void changeTab(int index) => emit(index);
}
