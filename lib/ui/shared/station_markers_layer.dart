import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/models/station_model.dart';

class StationMarkersLayer extends StatelessWidget {
  final List<StationModel> stations;
  final String? returnStationId;
  final String? selectedStationId;
  final ValueChanged<StationModel> onMarkerTap;
  final int Function(StationModel station) displayedValueBuilder;

  const StationMarkersLayer({
    super.key,
    required this.stations,
    required this.returnStationId,
    required this.selectedStationId,
    required this.onMarkerTap,
    required this.displayedValueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: stations.map((station) {
        final isReturn = returnStationId == station.id;
        final isSelected = selectedStationId == station.id;

        return Marker(
          point: LatLng(station.latitude, station.longitude),
          width: 52,
          height: 52,
          child: GestureDetector(
            onTap: () => onMarkerTap(station),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isReturn
                    ? const Color(0xFF006D33)
                    : isSelected
                    ? const Color(0xFF004D24)
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF006D33),
                  width: (isReturn || isSelected) ? 0 : 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isReturn
                  ? const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : Center(
                      child: Text(
                        '${displayedValueBuilder(station)}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF006D33),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
