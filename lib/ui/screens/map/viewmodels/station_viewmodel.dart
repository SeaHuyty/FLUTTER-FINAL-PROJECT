import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/models/station_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';

class StationViewModel extends AsyncNotifier<List<StationModel>> {
  @override
  Future<List<StationModel>> build() async {
    return fetchStations();
  }

  Future<List<StationModel>> fetchStations() async {
    final repository = ref.read(stationRepositoryProvider);
    return repository.getStations();
  }

  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    final repository = ref.read(stationRepositoryProvider);
    await repository.checkoutBike(stationId: stationId, bikeNumber: bikeNumber);
    ref.invalidateSelf();
  }

  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    final repository = ref.read(stationRepositoryProvider);
    await repository.dockBike(stationId: stationId, bikeNumber: bikeNumber);
    ref.invalidateSelf();
  }
}

final stationViewModelProvider =
    AsyncNotifierProvider<StationViewModel, List<StationModel>>(() {
      return StationViewModel();
    });
