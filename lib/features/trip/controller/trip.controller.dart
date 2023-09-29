import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trip_planner/common/services/storage.service.dart';
import 'package:trip_planner/features/trip/data/trips.respository.dart';
import 'package:trip_planner/models/ModelProvider.dart';

part 'trip.controller.g.dart';

@riverpod
class TripController extends _$TripController {
  Future<Trip> _fetchTrip(String tripId) async {
    final tripsRepository = ref.read(tripRepositoryProvider);
    return tripsRepository.getTrip(tripId);
  }

  @override
  FutureOr<Trip> build(String tripId) async {
    return _fetchTrip(tripId);
  }

  Future<void> updateTrip(Trip trip) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final tripsRepository = ref.read(tripRepositoryProvider);
      await tripsRepository.update(trip);
      return _fetchTrip(trip.id);
    });
  }

  Future<void> uploadFile(File file, Trip trip) async {
    final fileKey = await ref.read(storageServiceProvider).uploadFile(file);
    if (fileKey != null) {
      final imageUrl =
          await ref.read(storageServiceProvider).getImageUrl(fileKey);
      final updatedTrip =
          trip.copyWith(tripImageKey: fileKey, tripImageUrl: imageUrl);
      await ref.read(tripRepositoryProvider).update(updatedTrip);
      ref.read(storageServiceProvider).resetUploadProgress();
    }
  }

  ValueNotifier<double> uploadProgress() {
    return ref.read(storageServiceProvider).getUploadProgress();
  }
}