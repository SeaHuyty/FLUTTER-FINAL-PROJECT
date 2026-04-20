import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/station.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';

class StationViewModel extends ChangeNotifier {
  StationViewModel({StationRepository? repository})
    : _repository = repository ?? StationRepositoryFirebase() {
    unawaited(fetchStations());
  }

  final StationRepository _repository;
  List<StationModel> _stations = <StationModel>[];
  bool _isLoading = false;
  String? _error;

  List<StationModel> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStations() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stations = await _repository.getStations();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    await _repository.checkoutBike(
      stationId: stationId,
      bikeNumber: bikeNumber,
    );
    await fetchStations();
  }

  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  }) async {
    await _repository.dockBike(stationId: stationId, bikeNumber: bikeNumber);
    await fetchStations();
  }
}
