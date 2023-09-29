import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:trip_planner/features/trip/data/trips.respository.dart';
import 'package:trip_planner/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip.list.controller.g.dart';

@riverpod
class TripsListController extends _$TripsListController {
  Future<List<Trip>> _fetchTrips() async {
    final tripsRepository = ref.read(tripRepositoryProvider);
    final trips = await tripsRepository.getTrips();
    return trips;
  }

  @override
  FutureOr<List<Trip>> build() async {
    return _fetchTrips();
  }

  Future<void> addTrip({
    required String name,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    final trip = Trip(
      tripName: name,
      destination: destination,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final tripsRepository = ref.read(tripRepositoryProvider);
      await tripsRepository.add(trip);
      return _fetchTrips();
    });
  }

  Future<void> removeTrip(Trip trip) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final tripsRepository = ref.read(tripRepositoryProvider);
      await tripsRepository.delete(trip);

      return _fetchTrips();
    });
  }
}
