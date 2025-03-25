import 'package:bla_project_week7/data/repository/mock/mock_rides_repository.dart';
import 'package:bla_project_week7/service/rides_service.dart';
import 'package:bla_project_week7/ui/providers/ride_pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository/mock/mock_locations_repository.dart';
import 'service/locations_service.dart';

import 'data/repository/mock/mock_ride_preferences_repository.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';

void main() {
  // 1 - Initialize the services
  LocationsService.initialize(MockLocationsRepository());

  // 2 - Initialize the RidesService
  RidesService.initialize(MockRidesRepository()); 

  // 2- Run the UI
  runApp(
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> RidePreferencesProvider(repository:  MockRidePreferencesRepository()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()),
      ),
    );
  }
}
