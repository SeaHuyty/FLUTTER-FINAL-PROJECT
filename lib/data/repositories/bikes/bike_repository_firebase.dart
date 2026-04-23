import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_toulouse_redesign/data/repositories/bikes/bike_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';

class BikeRepositoryFirebase extends BikeRepository {
  final String _baseUrl = '${AppConfig.firebaseUrl}/stations';

  Future<void> _putBikes(String stationId, List<BikeModel> bikes) async {
    final Map<String, dynamic> bikesPayload = <String, dynamic>{
      for (int i = 0; i < bikes.length; i++) 'bike_$i': BikeModel.bikeToMap(bikes[i]),
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
  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    final stationRepo = StationRepositoryFirebase();
    final station = await stationRepo.getStationById(stationId);
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
    final stationRepo = StationRepositoryFirebase();
    final station = await stationRepo.getStationById(stationId);
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