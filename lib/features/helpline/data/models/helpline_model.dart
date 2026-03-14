// lib/features/helpline/data/models/helpline_model.dart

import '../../domain/entities/helpline_entity.dart';

class HelplineModel extends HelplineEntity {
  const HelplineModel({
    required super.country,
    required super.emergencyNumber,
    required super.helplineNumber,
    required super.helplineName,
    required super.flagEmoji,
  });
}
