import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/providers/pass_booking_provider.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/models/station_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/viewmodels/pass_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/viewmodels/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/widgets/station_bottom_sheet.dart';
import 'package:velo_toulouse_redesign/ui/shared/station_markers_layer.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showActivePassAlert();
    });
  }

  void _showActivePassAlert() {
    final viewModel = ref.read(passViewModelProvider.notifier);
    final user = ref.read(userViewModelProvider).value;

    if (viewModel.hasActivePass()) {
      final passTitle =
          ref.read(selectedPassProvider)?.title ?? user?.activePassTitle;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your $passTitle is active.'),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showStationInfo(StationModel station) {
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: screenHeight * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: StationBottomSheet(station: station),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(body: SizedBox.expand());
    }

    final stationsAsync = ref.watch(stationViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(13.3590756, 103.8709673),
              initialZoom: 13.5,
              onTap: (_, lng) => _showActivePassAlert(),
            ),
            children: [
              TileLayer(urlTemplate: AppConfig.mapboxTileUrl),
              stationsAsync.when(
                data: (stations) {
                  if (!mounted) return const MarkerLayer(markers: []);
                  return StationMarkersLayer(
                    stations: stations,
                    returnStationId: null,
                    selectedStationId: null,
                    onMarkerTap: (station) {
                      _showStationInfo(station);
                      _showActivePassAlert();
                    },
                    displayedValueBuilder: (station) => station.availableBikes,
                  );
                },
                error: (e, st) => const MarkerLayer(markers: []),
                loading: () => const MarkerLayer(markers: []),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
