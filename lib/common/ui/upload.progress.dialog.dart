import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/trip/controller/trip.controller.dart';

class UploadProgressDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: ValueListenableBuilder(
          valueListenable:
              ref.read(tripControllerProvider('').notifier).uploadProgress(),
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 15,
                ),
                Text('${(double.parse(value.toString()) * 100).toInt()} %'),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.all(20),
                  child: LinearProgressIndicator(
                    value: double.parse(value.toString()),
                    backgroundColor: Colors.blueGrey,
                    color: Colors.amber,
                    minHeight: 10,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
