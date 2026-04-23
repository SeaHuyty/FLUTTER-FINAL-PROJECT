import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/models/station.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/view_model/station_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/widgets/station_bottom_sheet_widget.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/station_markers_layer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showActivePassAlert();
    });
  }

  void _showActivePassAlert() {
    final user = context.read<UserViewModel>().user;
    final mv = context.read<StationViewModel>();

    if (DateFormatter.isFutureDate(user?.activePassExpiry)) {
      final passTitle = mv.resolveActivePassTitle(
        selectedPassTitle: user?.activePassTitle,
        userActivePassTitle: user?.activePassTitle,
      );

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
    final stationViewModel = context.watch<StationViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(13.3590756, 103.8709673),
              initialZoom: 13.5,
              onTap: (_, _) => _showActivePassAlert(),
            ),
            children: [
              TileLayer(urlTemplate: AppConfig.mapboxTileUrl),
              if (!stationViewModel.isLoading &&
                  stationViewModel.errorMessage == null)
                StationMarkersLayer(
                  stations: stationViewModel.stationList,
                  returnStationId: null,
                  selectedStationId: null,
                  onMarkerTap: (station) {
                    _showStationInfo(station);
                    _showActivePassAlert();
                  },
                  displayedValueBuilder: (station) => station.availableBikes,
                )
              else
                const MarkerLayer(markers: []),
            ],
          ),
        ],
      ),
    );
  }
}
