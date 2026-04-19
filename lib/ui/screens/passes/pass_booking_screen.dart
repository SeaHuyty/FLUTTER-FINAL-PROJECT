import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/models/bike_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/viewmodels/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/ui/shared/actions/button.dart';
import 'package:velo_toulouse_redesign/ui/shared/display/top_bar/app_bar.dart';

class PassbookingScreen extends ConsumerStatefulWidget {
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
  ConsumerState<PassbookingScreen> createState() => _BikeRentingScreenState();
}

class _BikeRentingScreenState extends ConsumerState<PassbookingScreen> {
  bool _isStartingRide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: StationAppBar(title: widget.stationName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF006D33),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(18),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: -50,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(13),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(46),
                          ),
                          child: Text(
                            "Station Info",
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          widget.stationName,
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.stationAddress,
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Divider(color: Colors.white.withAlpha(38)),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(38),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.directions_bike_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bike Selected",
                                  style: AppTextStyles.label.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.bike.plateNumber,
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 250),
            Center(
              child: VeloButton(
                text: "Start Riding",
                onPressed: _isStartingRide
                    ? null
                    : () async {
                        setState(() => _isStartingRide = true);

                        try {
                          try {
                            await ref
                                .read(stationViewModelProvider.notifier)
                                .checkoutBike(
                                  stationId: widget.stationId,
                                  bikeNumber: widget.bike.plateNumber,
                                );
                          } catch (_) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not unlock bike. Please try again.',
                                ),
                              ),
                            );
                            return;
                          }

                          ref
                              .read(rideSessionProvider.notifier)
                              .state = RideSession(
                            fromStationId: widget.stationId,
                            bikeNumber: widget.bike.plateNumber,
                            fromStationName: widget.stationName,
                            fromStationAddress: widget.stationAddress,
                          );

                          if (!context.mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActiveRideScreen(),
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isStartingRide = false);
                          }
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
