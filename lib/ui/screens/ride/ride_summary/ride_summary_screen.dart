import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/bottom_action_container.dart';
import 'package:velo_toulouse_redesign/ui/widgets/actions/button.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/success_header.dart';

class RideSummaryScreen extends StatelessWidget {
  final int secondsElapsed;

  const RideSummaryScreen({super.key, required this.secondsElapsed});

  String get _formattedDuration {
    final minutes = secondsElapsed ~/ 60;
    final seconds = secondsElapsed % 60;
    if (minutes == 0) return '${seconds}s';
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final rideSession = context.watch<RideSessionProvider>().session;
    if (rideSession == null) {
      return const Scaffold(
        body: Center(
          child: Text('No ride summary available. Please start again.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  const SuccessHeader(
                    title: 'Bike Returned!',
                    subtitle: 'Thanks for riding with Vélo Toulouse',
                    circleColor: Color(0xFF006D33),
                    iconColor: Colors.white,
                    circleSize: 80,
                    iconSize: 44,
                  ),

                  const SizedBox(height: 36),

                  // ── Summary card ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.07),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Summary',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _SummaryRow(
                          icon: Icons.directions_bike_rounded,
                          label: 'Bike',
                          value: rideSession.bikeNumber,
                        ),
                        const SizedBox(height: 14),
                        _SummaryRow(
                          icon: Icons.local_parking_rounded,
                          label: 'From',
                          value: rideSession.fromStationName,
                          subValue: rideSession.fromStationAddress,
                        ),
                        const SizedBox(height: 14),
                        _SummaryRow(
                          icon: Icons.local_parking_rounded,
                          label: 'Returned to',
                          value: rideSession.returnStationName ?? '-',
                          subValue: rideSession.returnStationAddress,
                        ),
                        const SizedBox(height: 14),
                        _SummaryRow(
                          icon: Icons.timer_rounded,
                          label: 'Duration',
                          value: _formattedDuration,
                        ),

                        const SizedBox(height: 16),
                        Divider(color: Colors.grey[200]),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount paid',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              '\$2.00',
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF006D33),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ────────────────────────────────────────────
          BottomActionContainer(
            child: VeloButton(
              text: 'Back to Map',
              onPressed: () {
                context.read<RideSessionProvider>().clear();
                // Pop all the way back to the map screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF006D33), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              if (subValue != null)
                Text(
                  subValue!,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
