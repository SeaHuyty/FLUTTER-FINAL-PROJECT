import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/data/dtos/station_dto.dart';
import 'package:velo_toulouse_redesign/models/station.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';

class StationRepositoryFirebase extends StationRepository {
  final String _baseUrl = '${AppConfig.firebaseUrl}/stations';

  Map<String, dynamic> _bikeToMap(BikeModel bike) {
    return <String, dynamic>{
      'plate_number': bike.plateNumber,
      'status': bike.status.name,
    };
  }

  Future<void> _putBikes(String stationId, List<BikeModel> bikes) async {
    final Map<String, dynamic> bikesPayload = <String, dynamic>{
      for (int i = 0; i < bikes.length; i++) 'bike_$i': _bikeToMap(bikes[i]),
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/$stationId/bikes.json'),
      body: jsonEncode(bikesPayload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update bikes for station $stationId');
    }
  }

  @override
  Future<List<StationModel>> getStations() async {
    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load stations');
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded == null) {
      return <StationModel>[];
    }

    final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);

    return data.entries
        .map((e) => StationDto.fromSnapshot(e.key, e.value))
        .toList();
  }

  @override
  Future<StationModel?> getStationById(String stationId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$stationId.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load station $stationId');
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded == null) return null;

    final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);
    return StationDto.fromSnapshot(stationId, data);
  }

  @override
  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    final station = await getStationById(stationId);
    if (station == null) {
      throw Exception('Station $stationId not found');
    }

    final bikeIndex = station.bikes.indexWhere(
      (b) => b.plateNumber == bikeNumber,
    );
    if (bikeIndex == -1) {
      throw Exception('Bike $bikeNumber not found in station $stationId');
    }

    final updated = <BikeModel>[...station.bikes];
    updated[bikeIndex] = BikeModel(
      plateNumber: updated[bikeIndex].plateNumber,
      status: BikeStatus.inUse,
    );

    updated.removeAt(bikeIndex);
    await _putBikes(stationId, updated);
  }

  @override
  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    final station = await getStationById(stationId);
    if (station == null) {
      throw Exception('Station $stationId not found');
    }

    if (station.bikes.any((b) => b.plateNumber == bikeNumber)) {
      await _putBikes(stationId, station.bikes);
      return;
    }

    final updated = <BikeModel>[
      ...station.bikes,
      BikeModel(plateNumber: bikeNumber, status: BikeStatus.docked),
    ];
    await _putBikes(stationId, updated);
  }
}
