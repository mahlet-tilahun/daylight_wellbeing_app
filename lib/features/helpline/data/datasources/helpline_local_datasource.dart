// lib/features/helpline/data/datasources/helpline_local_datasource.dart
// Helpline data is stored locally (no Firestore needed for static data).

import '../models/helpline_model.dart';

abstract class HelplineLocalDataSource {
  List<HelplineModel> getHelplines();
}

class HelplineLocalDataSourceImpl implements HelplineLocalDataSource {
  @override
  List<HelplineModel> getHelplines() {
    return const [
      HelplineModel(
        country: 'Rwanda',
        emergencyNumber: '112',
        helplineNumber: '2277',
        helplineName: 'Aheza Helpline',
        flagEmoji: '🇷🇼',
      ),
    ];
  }
}
