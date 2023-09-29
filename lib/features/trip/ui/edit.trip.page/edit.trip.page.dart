import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trip_planner/common/navigation/router/routes.dart';
import 'package:trip_planner/common/ui/bottomsheet.text.form.field.dart';
import 'package:trip_planner/common/utils/colors.dart';
import 'package:trip_planner/common/utils/date.time.formatter.dart';
import 'package:trip_planner/features/trip/controller/trip.controller.dart';
import 'package:trip_planner/models/ModelProvider.dart';

class EditTripPage extends ConsumerStatefulWidget {
  const EditTripPage({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  EditTripPageState createState() => EditTripPageState();
}

class EditTripPageState extends ConsumerState<EditTripPage> {
  @override
  void initState() {
    tripNameController.text = widget.trip.tripName;
    destinationController.text = widget.trip.destination;

    startDateController.text =
        widget.trip.startDate.getDateTime().format('yyyy-MM-dd');
    endDateController.text =
        widget.trip.endDate.getDateTime().format('yyyy-MM-dd');
    super.initState();
  }

  final formGlobalKey = GlobalKey<FormState>();
  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'amplify Trips Planner',
        ),
        leading: IconButton(
          onPressed: () {
            context.goNamed(
              AppRoute.trip.name,
              pathParameters: {'id': widget.trip.id},
            );
          },
          icon: Icon(
            MdiIcons.arrowLeft,
          ),
        ),
        backgroundColor: Color(primaryColorDark),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetFormField(
                  labelText: 'Trip Destination',
                  controller: destinationController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20,
                ),
                BottomSheetFormField(
                  labelText: 'Start Date',
                  controller: startDateController,
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      startDateController.text =
                          pickedDate.format('yyyy-MM-dd');
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BottomSheetFormField(
                  labelText: 'End Date',
                  controller: endDateController,
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    if (startDateController.text.isNotEmpty) {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(startDateController.text),
                        firstDate: DateTime.parse(startDateController.text),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        endDateController.text =
                            pickedDate.format('yyyy-MM-dd');
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    final currentState = formGlobalKey.currentState;
                    if (currentState == null) {
                      return;
                    }
                    if (currentState.validate()) {
                      final updatedTrip = widget.trip.copyWith(
                        tripName: tripNameController.text,
                        destination: destinationController.text,
                        startDate: TemporalDate(
                          DateTime.parse(startDateController.text),
                        ),
                        endDate: TemporalDate(
                          DateTime.parse(endDateController.text),
                        ),
                      );

                      await ref
                          .watch(
                              tripControllerProvider(widget.trip.id).notifier)
                          .updateTrip(updatedTrip);
                      if (context.mounted) {
                        context.goNamed(
                          AppRoute.trip.name,
                          pathParameters: {'id': widget.trip.id},
                          extra: updatedTrip,
                        );
                      }
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
