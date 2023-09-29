import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/common/navigation/router/routes.dart';
import 'package:trip_planner/features/trip/ui/trips.gridview/trip.gridview.item.card.dart';
import 'package:trip_planner/models/ModelProvider.dart';

class TripGridViewItem extends StatelessWidget {
  const TripGridViewItem({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        context.goNamed(
          AppRoute.trip.name,
          pathParameters: {'id': trip.id},
          extra: trip,
        );
      },
      child: TripGridViewItemCard(
        trip: trip,
      ),
    );
  }
}
