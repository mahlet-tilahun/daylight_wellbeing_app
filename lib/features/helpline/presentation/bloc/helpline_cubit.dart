// lib/features/helpline/presentation/bloc/helpline_cubit.dart
// Simple Cubit (lighter than BLoC) — just loads and holds helpline data.

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/helpline_entity.dart';
import '../../domain/repositories/helpline_repository.dart';

// State
class HelplineState extends Equatable {
  final List<HelplineEntity> helplines;
  final String? error;

  const HelplineState({this.helplines = const [], this.error});

  @override
  List<Object?> get props => [helplines, error];
}

// Cubit
class HelplineCubit extends Cubit<HelplineState> {
  final HelplineRepository repository;

  HelplineCubit({required this.repository}) : super(const HelplineState());

  void loadHelplines() {
    final result = repository.getHelplines();
    if (result.isSuccess) {
      emit(HelplineState(helplines: result.data!));
    } else {
      emit(HelplineState(error: result.error));
    }
  }
}
