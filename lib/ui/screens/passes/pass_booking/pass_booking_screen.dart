import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_booking/view_model/pass_booking_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_booking/widgets/pass_booking_content.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';

class PassbookingScreen extends StatelessWidget {
	final String stationId;
	final String stationName;
	final String stationAddress;
	final BikeModel bike;

	const PassbookingScreen({
		super.key,
		required this.stationId,
		required this.stationName,
		required this.stationAddress,
		required this.bike,
	});

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => PassBookingViewModel(
				stationRepository: context.read<StationRepository>(),
				rideSessionProvider: context.read<RideSessionViewModel>(),
				stationId: stationId,
				stationName: stationName,
				stationAddress: stationAddress,
				bike: bike,
			),
			child: const PassBookingContent(),
		);
	}
}
