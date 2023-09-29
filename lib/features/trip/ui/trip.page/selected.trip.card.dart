import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trip_planner/common/navigation/router/routes.dart';
import 'package:trip_planner/common/ui/upload.progress.dialog.dart';
import 'package:trip_planner/common/utils/colors.dart';
import 'package:trip_planner/features/trip/controller/trip.controller.dart';
import 'package:trip_planner/features/trip/controller/trip.list.controller.dart';
import 'package:trip_planner/features/trip/ui/trip.page/delete.trip.dialog.dart';
import 'package:trip_planner/models/Trip.dart';

class SelectedTripCard extends ConsumerWidget {
  const SelectedTripCard({
    required this.trip,
    super.key,
  });

  final Trip trip;

  Future<bool> uploadImage({
    required BuildContext context,
    required WidgetRef ref,
    required Trip trip,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return false;
    }
    final file = File(pickedFile.path);
    if (context.mounted) {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UploadProgressDialog();
        },
      );

      await ref
          .watch(tripControllerProvider(trip.id).notifier)
          .uploadFile(file, trip);
    }

    return true;
  }

  Future<bool> deleteTrip(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    var value = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const DeleteTripDialog();
      },
    );
    value ??= false;

    if (value) {
      await ref.watch(tripsListControllerProvider.notifier).removeTrip(trip);
    }
    return value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trip.tripName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.center,
            color: const Color(primaryColorDark),
            height: 150,
            child: trip.tripImageUrl != null
                ? Stack(
                    children: [
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      CachedNetworkImage(
                        imageUrl: trip.tripImageUrl!,
                        cacheKey: trip.tripImageKey,
                        width: double.maxFinite,
                        height: 500,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill,
                      ),
                    ],
                  )
                : Image.asset(
                    'assets/customer-journey.png',
                    fit: BoxFit.contain,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  context.goNamed(
                    AppRoute.editTrip.name,
                    pathParameters: {'id': trip.id},
                    extra: trip,
                  );
                },
                icon: Icon(MdiIcons.pencil),
              ),
              IconButton(
                onPressed: () {
                  uploadImage(context: context, ref: ref, trip: trip)
                      .then((value) {
                    if (value) {
                      Navigator.of(context, rootNavigator: true).pop();
                      ref.invalidate(tripControllerProvider(trip.id));
                    }
                  });
                },
                icon: Icon(MdiIcons.cameraPlus),
              ),
              IconButton(
                onPressed: () {
                  deleteTrip(context, ref, trip).then((value) {
                    if (value) {
                      context.goNamed(
                        AppRoute.home.name,
                      );
                    }
                  });
                },
                icon: Icon(MdiIcons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}
