import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/data/repositories/bikes/bike_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/bikes/bike_repository_firebase.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/view_model/station_view_model.dart';

class BikeViewModel extends ChangeNotifier {
  BikeViewModel({BikeRepository? repository, required this.stationViewModel})
    : repository = repository ?? BikeRepositoryFirebase();

  final BikeRepository repository;
  final StationViewModel stationViewModel;

  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    await repository.checkoutBike(stationId: stationId, bikeNumber: bikeNumber);
    await stationViewModel.fetchStations();
  }

  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    await repository.dockBike(stationId: stationId, bikeNumber: bikeNumber);
    await stationViewModel.fetchStations();
  }
}
