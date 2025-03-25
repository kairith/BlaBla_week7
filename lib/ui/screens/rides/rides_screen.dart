import 'package:bla_project_week7/ui/providers/ride_pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
// ignore: must_be_immutable
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  RideFilter currentFilter = RideFilter();

  // List<Ride> get matchingRides =>
  //     RidesService.instance.getRidesFor(currentPreference, currentFilter);

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // Update the current preference using the provider
    context.read<RidePreferencesProvider>().setCurrentPreference(newPreference);

    // Navigate to the rides screen (with a bottom-to-top animation)
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(RidesScreen()),
    );
  }

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      context
          .read<RidePreferencesProvider>()
          .setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidePreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Watch the RidePreferencesProvider to get the current preference and past preferences
    // RidePreference? currentRidePreference =
    //     context.watch<RidePreferencesProvider>().currentPreference;
    // List<RidePreference> pastPreferences =
    //     context.watch<RidePreferencesProvider>().preferencesHistory;
    if (currentPreference == null) {
      return const Center(child: Text('No ride preference selected'));
    }

    // Get matching rides based on current preference
    final RideFilter currentFilter = RideFilter();
    final List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
