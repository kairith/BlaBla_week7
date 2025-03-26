import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/ride/ride_pref.dart';
import '../../dto/ride_preference_dto.dart';
import '../ride_preferences_repository.dart';

class LocalRidePreferencesRepository implements RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    /// Get SharedPreferences instance 
    final prefs = await SharedPreferences.getInstance();
    /// Get the list of preferences from SharedPreferences
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    /// Convert the list of JSON strings to a list of RidePreference objects
    return prefsList.map((json) => RidePreferenceDto.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    /// Get SharedPreferences instance 
    final prefs = await SharedPreferences.getInstance();
    /// Get the list of preferences from SharedPreferences
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    /// Add the new preference to the list
    prefsList.add(jsonEncode(RidePreferenceDto.toJson(preference)));
    await prefs.setStringList(_preferencesKey, prefsList);
  }
}