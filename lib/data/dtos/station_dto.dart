import 'package:velo_toulouse_redesign/data/dtos/bike_dto.dart';
import 'package:velo_toulouse_redesign/models/station_model.dart';

class StationDto {
  static const String name = 'name';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String capacity = 'capacity';
  static const String address = 'address';
  static const String jsonBikes = 'bikes';

  static StationModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    final rawBikes = Map<String, dynamic>.from(data[jsonBikes] ?? {});
    final bikes = rawBikes.entries
        .map((e) => BikeDto.fromSnapshot(e.key, e.value))
        .toList();
        
    return StationModel(
      id: key,
      name: data[name] as String,
      latitude: (data[latitude] as num).toDouble(),
      longitude: (data[longitude] as num).toDouble(),
      capacity: (data[capacity] as num).toInt(),
      address: data[address] as String,
      bikes: bikes,
    );
}
}