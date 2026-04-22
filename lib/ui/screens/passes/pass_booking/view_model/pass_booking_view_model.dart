import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/models/ride_session.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';

class PassBookingViewModel extends ChangeNotifier {
  final StationRepository stationRepository;
  final RideSessionViewModel rideSessionProvider;
  final String stationId;
  final String stationName;
  final String stationAddress;
  final BikeModel bike;

  PassBookingViewModel({
    required this.stationRepository,
    required this.rideSessionProvider,
    required this.stationId,
    required this.stationName,
    required this.stationAddress,
    required this.bike,
  });

  AsyncValue<void> startRideState = AsyncValue.success(null);

  bool get isStartingRide => startRideState.state == AsyncValueState.loading;
  String get activePassMessage => 'Your Monthly Pass is active.';
  String get startRideButtonText => 'Start Riding';
  String get startRideErrorMessage => startRideState.error?.toString().trim().isNotEmpty == true? startRideState.error!.toString().trim()
      : 'Could not unlock bike. Please try again.';

  Future<bool> startRide() async {
    if (isStartingRide) {
      return false;
    }

    startRideState = AsyncValue.loading();
    notifyListeners();

    try {
      await stationRepository.checkoutBike(
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
}
