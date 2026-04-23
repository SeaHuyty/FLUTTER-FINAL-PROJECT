import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/repositories/bikes/bike_repository.dart';
import 'package:velo_toulouse_redesign/models/ride_session.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';

class PassBookingViewModel extends ChangeNotifier {
  final BikeRepository bikeRepository;
  final RideSessionViewModel rideSessionProvider;
  final String stationId;
  final String stationName;
  final String stationAddress;
  final BikeModel bike;

  PassBookingViewModel({
    required this.bikeRepository,
    required this.rideSessionProvider,
    required this.stationId,
    required this.stationName,
    required this.stationAddress,
    required this.bike,
  });

  AsyncValue<void> startRideState = AsyncValue.success(null);


  Future<bool> startRide() async {
    if (isStartingRide) {
      return false;
    }
    startRideState = AsyncValue.loading();
    notifyListeners();

    try {
      await bikeRepository.checkoutBike(
        stationId: stationId,
        bikeNumber: bike.plateNumber,
      );

      rideSessionProvider.setSession(
        RideSession(
          fromStationId: stationId,
          bikeNumber: bike.plateNumber,
          fromStationName: stationName,
          fromStationAddress: stationAddress,
        ),
      );

      startRideState = AsyncValue.success(null);
      notifyListeners();
      return true;
    } catch (e) {
      startRideState = AsyncValue.error(e);
      notifyListeners();
      return false;
    }
  }

  bool get isStartingRide => startRideState.state == AsyncValueState.loading;
}
