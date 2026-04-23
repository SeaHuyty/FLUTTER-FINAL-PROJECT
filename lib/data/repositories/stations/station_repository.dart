import 'package:velo_toulouse_redesign/models/station.dart';

abstract class StationRepository {
  Future<List<StationModel>> getStations();

  Future<StationModel?> getStationById(String stationId);
}
