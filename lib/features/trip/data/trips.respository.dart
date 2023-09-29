import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/trip/service/trips.api.service.dart';
import 'package:trip_planner/models/Trip.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final tripsApiService = ref.read(tripsAPIServiceProvider);
  return TripRepository(tripsApiService);
});

class TripRepository {
  TripRepository(this.tripsApiService);

  final TripsAPIService tripsApiService;

  Future<List<Trip>> getTrips() {
    return tripsApiService.getTrips();
  }

  Future<void> add(Trip trip) async {
    return tripsApiService.addTrip(trip);
  }

  Future<void> update(Trip updatedTrip) async {
    return tripsApiService.updateTrip(updatedTrip);
  }

  Future<void> delete(Trip deletedTrip) async {
    return tripsApiService.deleteTrip(deletedTrip);
  }

  Future<Trip> getTrip(String tripId) async {
    return tripsApiService.getTrip(tripId);
  }
}
