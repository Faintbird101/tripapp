import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/common/ui/bottomsheet.text.form.field.dart';
import 'package:trip_planner/common/utils/date.time.formatter.dart';
import 'package:trip_planner/features/trip/controller/trip.list.controller.dart';

class AddTripBottomSheet extends ConsumerStatefulWidget {
  const AddTripBottomSheet({
    super.key,
  });

  @override
  AddTripBottomSheetState createState() => AddTripBottomSheetState();
}

class AddTripBottomSheetState extends ConsumerState<AddTripBottomSheet> {
  final formGlobalKey = GlobalKey<FormState>();

  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BottomSheetFormField(
              labelText: 'Trip Name',
              controller: tripNameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 20,
            ),
            //startDate
            BottomSheetFormField(
              labelText: "Start Date",
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
                  log(pickedDate.format('yyyy-MM-dd'));
                  startDateController.text = pickedDate.format('yyyy-MM-dd');
                  log('startDate ${startDateController.text}');
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            //endDate
            BottomSheetFormField(
              labelText: "End Date",
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
                    log(pickedDate.format('yyyy-MM-dd'));
                    endDateController.text = pickedDate.format('yyyy-MM-dd');
                    log('endDate ${startDateController.text}');
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
                  await ref.watch(tripsListControllerProvider.notifier).addTrip(
                        name: tripNameController.text,
                        destination: destinationController.text,
                        startDate: startDateController.text,
                        endDate: endDateController.text,
                      );

                  if (context.mounted) {
                    context.pop();
                  }
                }
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}
