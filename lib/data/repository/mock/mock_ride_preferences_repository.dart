import '../../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

import '../../../dummy_data/dummy_data.dart';
import 'dart:async';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = fakeRidePrefs;

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Simulate a 2-second delay before returning data
    await Future.delayed(Duration(seconds: 2));
    return _pastPreferences;
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    // Wait for 2-second before returning data
    await Future.delayed(Duration(seconds: 2));
    _pastPreferences.add(preference);
  }
}
