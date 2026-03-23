// lib/features/helpline/domain/entities/helpline_entity.dart
import 'package:equatable/equatable.dart';


class HelplineEntity extends Equatable {
  final String country;
  final String emergencyNumber;
  final String helplineNumber;
  final String helplineName;
  final String flagEmoji;

  

  @override
  List<Object> get props =>
      [country, emergencyNumber, helplineNumber, helplineName, flagEmoji];
}
