import 'package:bla_project_week7/ui/providers/async_value.dart';
import 'package:bla_project_week7/ui/providers/ride_pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference by provider
    context.read<RidePreferencesProvider>().setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidePreferencesProvider>();
    final currentRidePreference = provider.currentPreference;
    final pastPreferences = provider.pastPreferences;

    Widget content;

    switch (pastPreferences.state) {
      case AsyncValueState.loading:
        content = const Center(child: Text('Loading...'));
        break;
      case AsyncValueState.error:
        content = const Center(child: Text('No connection. Try later'));
        break;
      case AsyncValueState.success:
        List<RidePreference> pastPref = pastPreferences.data!;
        content = Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPreference) =>
                          onRidePrefSelected(context, newPreference)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                    height: 200, // Set a fixed height
                    child: ListView.builder(
                      shrinkWrap: true, // Fix ListView height issue
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: pastPref.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPref[index],
                        onPressed: () =>
                            onRidePrefSelected(context, pastPref[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case AsyncValueState.empty:
        content =
            const Center(child: Text('Fetching data failed, please try again'));
        break;
    }
    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        content,
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
