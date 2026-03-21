// lib/features/helpline/domain/entities/helpline_entity.dart

import 'package:equatable/equatable.dart';

class HelplineEntity extends Equatable {
  final String country;
  final String emergencyNumber;
  final String helplineNumber;
  final String helplineName;
  final String flagEmoji;

  const HelplineEntity({
    required this.country,
    required this.emergencyNumber,
    required this.helplineNumber,
    required this.helplineName,
    required this.flagEmoji,
  });

  @override
  List<Object> get props =>
      [country, emergencyNumber, helplineNumber, helplineName, flagEmoji];
}
