import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trip_planner/common/navigation/router/routes.dart';
import 'package:trip_planner/common/utils/colors.dart';
import 'package:trip_planner/features/trip/controller/trip.controller.dart';
import 'package:trip_planner/features/trip/ui/trip.page/trip.details.dart';

class TripPage extends ConsumerWidget {
  const TripPage({
    required this.tripId,
    super.key,
  });

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripValue = ref.watch(tripControllerProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aws Trips Planner,'),
        actions: [
          IconButton(
              onPressed: () {
                context.goNamed(
                  AppRoute.home.name,
                );
              },
              icon: Icon(MdiIcons.home))
        ],
        backgroundColor: const Color(primaryColorDark),
      ),
      body: TripDetails(trip: tripValue, tripId: tripId),
    );
  }
}
