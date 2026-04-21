import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';
import 'package:velo_toulouse_redesign/models/bike.dart';
import 'package:velo_toulouse_redesign/models/station.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
	MapViewModel({StationRepository? repository}) : _repository = repository ?? StationRepositoryFirebase() {
		unawaited(fetchStations());
	}

	final StationRepository _repository;

	AsyncValue<List<StationModel>> stations = AsyncValue.loading();
	BikeModel? selectedBike;

	List<StationModel> get stationList => stations.data ?? <StationModel>[];
	bool get isLoading => stations.state == AsyncValueState.loading;
	String? get errorMessage =>
			stations.state == AsyncValueState.error ? stations.error.toString() : null;

	Future<void> fetchStations() async {
		stations = AsyncValue.loading();
		notifyListeners();

		try {
			final result = await _repository.getStations();
			stations = AsyncValue.success(result);
		} catch (e) {
			stations = AsyncValue.error(e);
		}

		notifyListeners();
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

	void setBike(BikeModel bike) {
		selectedBike = bike;
		notifyListeners();
	}

	String? resolveActivePassTitle({
		required String? selectedPassTitle,
		required String? userActivePassTitle,
	}) {
		return selectedPassTitle ?? userActivePassTitle;
	}
}
