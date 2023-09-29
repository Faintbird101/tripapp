
import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:trip_planner/models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripsAPIServiceProvider = Provider<TripsAPIService>((ref) {
  final service = TripsAPIService();
  return service;
});

class TripsAPIService {
  TripsAPIService();

  Future<List<Trip>> getTrips() async {
    try {
      final request = ModelQueries.list(Trip.classType);
      final response = await Amplify.API.query(request: request).response;

      final trips = response.data?.items;
      if (trips == null) {
        safePrint('getTrips errors: ${response.errors}');
        return const [];
      }
      trips.sort(
        (a, b) =>
            a!.startDate.getDateTime().compareTo(b!.startDate.getDateTime()),
      );
      return trips
          .map((e) => e as Trip)
          .where(
            (element) => element.endDate.getDateTime().isAfter(DateTime.now()),
          )
          .toList();
    } on Exception catch (error) {
      safePrint('getTrips failed: $error');

      return const [];
    }
  }

  Future<List<Trip>> getPastTrips() async {
    try {
      final request = ModelQueries.list(Trip.classType);
      final response = await Amplify.API.query(request: request).response;

      final trips = response.data?.items;
      if (trips == null) {
        safePrint('getPastTrips errors: ${response.errors}');
        return const [];
      }
      trips.sort(
        (a, b) =>
            a!.startDate.getDateTime().compareTo(b!.startDate.getDateTime()),
      );
      return trips
          .map((e) => e as Trip)
          .where(
            (element) => element.endDate.getDateTime().isBefore(DateTime.now()),
          )
          .toList();
    } on Exception catch (error) {
      safePrint('getPastTrips failed: $error');

      return const [];
    }
  }

  Future<void> addTrip(Trip trip) async {
    try {
      final request = ModelMutations.create(trip);
      final response = await Amplify.API.mutate(request: request).response;

      final createdTrip = response.data;
      if (createdTrip == null) {
        safePrint('addTrip errors: ${response.errors}');
        return;
      }
    } on Exception catch (error) {
      safePrint('addTrip failed: $error');
    }
  }

  Future<void> deleteTrip(Trip trip) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(trip),
          )
          .response;
    } on Exception catch (error) {
      safePrint('deleteTrip failed: $error');
    }
  }

  Future<void> updateTrip(Trip updatedTrip) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.update(updatedTrip),
          )
          .response;
    } on Exception catch (error) {
      safePrint('updateTrip failed: $error');
    }
  }

  Future<Trip> getTrip(String tripId) async {
    try {
      final request = ModelQueries.get(
        Trip.classType,
        TripModelIdentifier(id: tripId),
      );
      final response = await Amplify.API.query(request: request).response;

      final trip = response.data!;
      return trip;
    } on Exception catch (error) {
      safePrint('getTrip failed: $error');
      rethrow;
    }
  }
}

// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:trip_planner/models/ModelProvider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final tripsApiServiceProvider = Provider<TripsAPIService>((ref) {
//   final service = TripsAPIService();
//   return service;
// });

// class TripsAPIService {
//   TripsAPIService();

//   Future<List<Trip>> getTrips() async {
//     try {
//       final request = ModelQueries.list(Trip.classType);
//       final response = await Amplify.API.query(request: request).response;

//       final trips = response.data?.items;
//       if (trips == null) {
//         safePrint('getTrips errors: ${response.errors}');
//         return const [];
//       }
//       trips.sort(
//         (a, b) => a!.startDate.getDateTime().compareTo(
//               b!.startDate.getDateTime(),
//             ),
//       );
//       return trips
//           .map((e) => e as Trip)
//           .where(
//             (element) => element.endDate.getDateTime().isAfter(DateTime.now()),
//           )
//           .toList();
//     } on Exception catch (e) {
//       safePrint('getTrips failed: $e');
//       return const [];
//     }
//   }

//   Future<List<Trip>> getPastTrips() async {
//     try {
//       final request = ModelQueries.list(Trip.classType);
//       final response = await Amplify.API.query(request: request).response;

//       final trips = response.data?.items;
//       if (trips == null) {
//         safePrint('getPastTrips errors: ${response.errors}');
//         return const [];
//       }
//       trips.sort(
//         (a, b) => a!.startDate.getDateTime().compareTo(
//               b!.startDate.getDateTime(),
//             ),
//       );
//       return trips
//           .map((e) => e as Trip)
//           .where(
//             (element) => element.endDate.getDateTime().isBefore(DateTime.now()),
//           )
//           .toList();
//     } on Exception catch (e) {
//       safePrint('getPastTrips Errors: $e');
//       return const [];
//     }
//   }

//   Future<void> addTrip(Trip trip) async {
//     try {
//       final request = ModelMutations.create(trip);
//       final response = await Amplify.API.mutate(request: request).response;

//       final createdTrip = response.data;
//       if (createdTrip == null) {
//         safePrint('addTrip failed: ${response.errors}');
//         return;
//       }
//     } on Exception catch (e) {
//       safePrint('addTrip Failed: $e');
//     }
//   }

//   Future<void> deleteTrip(Trip trip) async {
//     try {
//       await Amplify.API
//           .mutate(
//             request: ModelMutations.delete(trip),
//           )
//           .response;
//     } on Exception catch (e) {
//       safePrint('deleteTrip failed: $e');
//     }
//   }

//   Future<void> updateTrip(Trip updatedtrip) async {
//     try {
//       await Amplify.API
//           .mutate(
//             request: ModelMutations.update(updatedtrip),
//           )
//           .response;
//     } on Exception catch (e) {
//       safePrint('updateTrip failed: $e');
//     }
//   }

//   Future<Trip> getTrip(String tripId) async {
//     try {
//       final request = ModelQueries.get(
//         Trip.classType,
//         TripModelIdentifier(id: tripId),
//       );
//       final response = await Amplify.API.query(request: request).response;

//       final trip = response.data!;
//       return trip;
//     } on Exception catch (e) {
//       safePrint('getTrip failed: $e');
//       rethrow;
//     }
//   }
// }
