import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trip_planner/common/utils/colors.dart' as constants;
import 'package:trip_planner/features/trip/controller/trip.list.controller.dart';
import 'package:trip_planner/features/trip/ui/trip.list/add.trip.bottomsheet.dart';
import 'package:trip_planner/features/trip/ui/trips.gridview/trip.list.gridview.dart';

class TripsListPage extends ConsumerWidget {
  const TripsListPage({super.key});

  Future<void> showAddTripDialog(BuildContext context) =>
      showModalBottomSheet<void>(
          isScrollControlled: true,
          elevation: 5,
          context: context,
          builder: (sheetContext) {
            return const AddTripBottomSheet();
          });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsListValue = ref.watch(tripsListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        actions: const [
          SignOutButton(),
          // IconButton(
          //   onPressed: () {
          //     // SignOutButton();
          //     const SignOutOptions(
          //       globalSignOut: true,
          //     );
          //   },
          //   icon: Icon(MdiIcons.logout),
          // )
        ],
        centerTitle: true,
        title: const Text('Trip Planner'),
      ),
      backgroundColor: Colors.deepPurple[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTripDialog(context);
        },
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: TripListGridView(
        tripslist: tripsListValue,
      ),
    );
  }
}
