import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trip_planner/common/utils/colors.dart';
import 'package:trip_planner/common/utils/date.time.formatter.dart';
import 'package:trip_planner/models/ModelProvider.dart';

class TripGridViewItemCard extends StatelessWidget {
  const TripGridViewItemCard({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 500,
              alignment: Alignment.center,
              color: const Color(primaryColorDark).withOpacity(0.8),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: trip.tripImageUrl != null
                        ? Stack(
                            children: [
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              CachedNetworkImage(
                                imageUrl: trip.tripImageUrl!,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error_outline_outlined,
                                ),
                                cacheKey: trip.tripImageKey,
                                width: double.maxFinite,
                                height: 500,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.fill,
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              MdiIcons.transitConnectionVariant,
                              size: 70,
                            ),
                          ),
                    // Image.asset(
                    //     'assets/destination (1).png',
                    //     fit: BoxFit.contain,
                    //     scale: 20.0,
                    //   ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        trip.destination,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 8, 4),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleMedium!,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(
                      trip.tripName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ),
                  Text(
                    trip.startDate.getDateTime().format('MMMM dd, yyyy'),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    trip.endDate.getDateTime().format('MMMM dd, yyyy'),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
