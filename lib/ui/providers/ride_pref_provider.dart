import 'package:bla_project_week7/data/repository/ride_preferences_repository.dart';
import 'package:bla_project_week7/model/ride/ride_pref.dart';
import 'package:bla_project_week7/ui/providers/async_value.dart';
import 'package:flutter/material.dart';


class RidePreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;

  RidePreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time
    _fetchPastPreferences();
  }

  // Method to get currentPreference
  RidePreference? get currentPreference => _currentPreference;

  // Set currentPreference
  void setCurrentPreference(RidePreference pref) {
    if (currentPreference != pref) {
      _currentPreference = pref;
    }

    bool isHistory = pastPreferences.data?.contains(pref) ?? false;
    if (!isHistory) {
      addPreference(pref);
    }

    notifyListeners();
  }

  // Add a new preference
  void addPreference(RidePreference pref) async {
    if (!pastPreferences.data!.contains(pref)) {
      pastPreferences.data!.add(pref);
      await repository.addPreference(pref);
    }
  }

  Future<void> _fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      // 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  // Get the past preferences (from the newest to the lasted)
  List<RidePreference> get preferencesHistory =>
      pastPreferences.data?.reversed.toList() ?? [];
}
