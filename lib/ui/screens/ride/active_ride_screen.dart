import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/alert_dialog_modal.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/view_model/ride_history_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_summary_screen.dart';
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';
import 'package:velo_toulouse_redesign/models/station.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/legend_pill.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/ride_bottom_sheet.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/widgets/station_selection_card.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/station_markers_layer.dart';

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
    final rideSession = context.read<RideSessionViewModel>().session;
    if (rideSession == null || _returnStation == null) return;

    try {
      await context.read<MapViewModel>().dockBike(
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
    context.read<RideSessionViewModel>().setSession(
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
    if (_returnStation == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialogModal(
        stationName: _returnStation!.name,
        onConfirm: _onDocked,
      ),
    );
  }

  List<StationModel> _returnableStations(List<StationModel> stations) =>
      stations.where((s) => s.availableSpots > 0).toList();

  @override
  Widget build(BuildContext context) {
    final rideSession = context.watch<RideSessionViewModel>().session;
    if (rideSession == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active ride session found. Please start again.'),
        ),
      );
    }

    final stationViewModel = context.watch<MapViewModel>();
    final hasReturnStation = _returnStation != null;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full screen map ───────────────────────────────────────
          if (!stationViewModel.isLoading &&
              stationViewModel.errorMessage == null)
            Builder(
              builder: (_) {
                final returnable = _returnableStations(
                  stationViewModel.stationList,
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
