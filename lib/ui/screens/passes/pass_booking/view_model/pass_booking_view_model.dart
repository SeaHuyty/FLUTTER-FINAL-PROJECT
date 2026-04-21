import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/view_model/map_view_model.dart';

class PassBookingViewModel extends ChangeNotifier {
	final MapViewModel stationViewModel;
	final RideSessionProvider rideSessionProvider;
	final String stationId;
	final String stationName;
	final String stationAddress;
	final BikeModel bike;

	PassBookingViewModel({
		required this.stationViewModel,
		required this.rideSessionProvider,
		required this.stationId,
		required this.stationName,
		required this.stationAddress,
		required this.bike,
	});

	bool isStartingRide = false;

	Future<bool> startRide() async {
		if (isStartingRide) {
			return false;
		}

		isStartingRide = true;
		notifyListeners();

		try {
			await stationViewModel.checkoutBike(
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

			return true;
		} catch (_) {
			return false;
		} finally {
			isStartingRide = false;
			notifyListeners();
		}
	}
}
