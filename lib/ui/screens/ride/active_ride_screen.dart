import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/models/station_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/viewmodels/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/viewmodels/ride_history_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_summary_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/legend_pill.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/ride_bottom_sheet.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/station_selection_card.dart';
import 'package:velo_toulouse_redesign/ui/shared/station_markers_layer.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  late final Timer _timer;
  int _secondsElapsed = 0;
  StationModel? _returnStation;
  StationModel? _selectedStation;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _secondsElapsed++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _secondsElapsed ~/ 60;
    final seconds = _secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onMarkerTap(StationModel station) {
    setState(() => _selectedStation = station);
  }

  void _dismissStationCard() {
    setState(() => _selectedStation = null);
  }

  void _setReturnStation(StationModel station) {
    setState(() {
      _returnStation = station;
      _selectedStation = null;
    });
  }

  Future<void> _onDocked() async {
    final rideSession = context.read<RideSessionProvider>().session;
    if (rideSession == null || _returnStation == null) return;

    try {
      await context.read<StationViewModel>().dockBike(
        stationId: _returnStation!.id,
        bikeNumber: rideSession.bikeNumber,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not complete docking. Please try again.'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    if (rideSession.sessionId != null) {
      await context.read<RideHistoryViewModel>().completeRide(
        sessionId: rideSession.sessionId!,
        returnStationName: _returnStation!.name,
        returnStationAddress: _returnStation!.address,
        durationSeconds: _secondsElapsed,
      );
    }

    if (!mounted) return;
    context.read<RideSessionProvider>().setSession(
      rideSession.copyWith(
        returnStationName: _returnStation!.name,
        returnStationAddress: _returnStation!.address,
      ),
    );


    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RideSummaryScreen(secondsElapsed: _secondsElapsed),
      ),
    );
  }

  void _showDockConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF4F6F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF006D33),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm Return',
              style: AppTextStyles.heading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your bike is fully locked into the slot at ${_returnStation!.name} before confirming.',
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: Colors.grey[500],
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  _onDocked(); // then navigate
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D33),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Yes, bike is locked',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Go back',
                style: AppTextStyles.label.copyWith(
                  color: Colors.grey[500],
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StationModel> _returnableStations(List<StationModel> stations) =>
      stations.where((s) => s.availableSpots > 0).toList();

  @override
  Widget build(BuildContext context) {
    final rideSession = context.watch<RideSessionProvider>().session;
    if (rideSession == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active ride session found. Please start again.'),
        ),
      );
    }

    final stationViewModel = context.watch<StationViewModel>();
    final hasReturnStation = _returnStation != null;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full screen map ───────────────────────────────────────
          if (!stationViewModel.isLoading && stationViewModel.error == null)
            Builder(
              builder: (_) {
                final returnable = _returnableStations(
                  stationViewModel.stations,
                );
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: const LatLng(13.3590756, 103.8709673),
                    initialZoom: 13.5,
                    onTap: (_, _) => _dismissStationCard(),
                  ),
                  children: [
                    TileLayer(urlTemplate: AppConfig.mapboxTileUrl),
                    StationMarkersLayer(
                      stations: returnable,
                      returnStationId: _returnStation?.id,
                      selectedStationId: _selectedStation?.id,
                      onMarkerTap: _onMarkerTap,
                      displayedValueBuilder: (station) =>
                          station.availableSpots,
                    ),
                  ],
                );
              },
            )
          else
            const SizedBox.expand(),

          // ── Legend pill ───────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: const LegendPill(
                text: 'Tap a station to return your bike',
              ),
            ),
          ),

          // ── Station selection bottom card ─────────────────────────
          if (_selectedStation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 230,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StationSelectionCard(
                  station: _selectedStation!,
                  isCurrentReturn: _returnStation?.id == _selectedStation!.id,
                  onConfirm: () => _setReturnStation(_selectedStation!),
                ),
              ),
            ),

          // ── Floating bottom ride sheet ─────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RideBottomSheet(
              formattedTime: _formattedTime,
              bikeNumber: rideSession.bikeNumber,
              returnStation: _returnStation,
              hasReturnStation: hasReturnStation,
              onDocked: _showDockConfirmation,
              onClearReturn: () => setState(() => _returnStation = null),
            ),
          ),
        ],
      ),
    );
  }
}
