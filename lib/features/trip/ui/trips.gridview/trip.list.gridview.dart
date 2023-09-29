import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/trip/ui/trips.gridview/trip.gridview.item.dart';
import 'package:trip_planner/models/ModelProvider.dart';

class TripListGridView extends StatelessWidget {
  const TripListGridView({
    super.key,
    required this.tripslist,
  });

  final AsyncValue<List<Trip>> tripslist;

  @override
  Widget build(BuildContext context) {
    switch (tripslist) {
      case AsyncData(:final value):
        return value.isEmpty
            ? const Center(
                child: Text('No Trips'),
              )
            : OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 2 : 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    padding: const EdgeInsets.all(4),
                    childAspectRatio:
                        (orientation == Orientation.portrait) ? 0.9 : 1.4,
                    children: value.map((tripData) {
                      return TripGridViewItem(
                        trip: tripData,
                      );
                    }).toList(growable: false),
                  );
                },
              );
      case AsyncError():
        return const Center(
          child: Text('Error'),
        );
      case AsyncLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );
      case _:
        return const Center(
          child: Text('Error'),
        );
    }
  }
}
