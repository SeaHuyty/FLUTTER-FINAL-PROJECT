import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velo_toulouse_redesign/data/dtos/ride_history_dto.dart';
import 'package:velo_toulouse_redesign/models/ride_history.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_firebase_repository.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';

class RideHistoryViewModel extends ChangeNotifier {
  RideHistoryViewModel({RideHistoryRepository? repository})
    : _repository = repository ?? RideHistoryFirebaseRepository();

  final RideHistoryRepository _repository;
  String? _authUid;
  AsyncValue<List<RideHistoryModel>> _historyState = AsyncValue.success(
    <RideHistoryModel>[],
  );

  AsyncValue<List<RideHistoryModel>> get historyState => _historyState;
  List<RideHistoryModel> get rides =>
      _historyState.data ?? <RideHistoryModel>[];
  bool get isLoading => _historyState.state == AsyncValueState.loading;
  bool get isSuccess => _historyState.state == AsyncValueState.success;
  String? get error => _historyState.state == AsyncValueState.error
      ? _historyState.error.toString()
      : null;

  Future<void> onAuthUserChanged(User? authUser) async {
    final newUid = authUser?.uid;
    if (_authUid == newUid) return;
    _authUid = newUid;

    if (_authUid == null) {
      _historyState = AsyncValue.success(<RideHistoryModel>[]);
      notifyListeners();
      return;
    }

    await fetchHistory();
  }

  Future<void> fetchHistory() async {
    if (_authUid == null) {
      _historyState = AsyncValue.success(<RideHistoryModel>[]);
      notifyListeners();
      return;
    }

    _historyState = AsyncValue.loading();
    notifyListeners();
    try {
      final result = await _repository.getHistoryForUser(_authUid!);
      _historyState = AsyncValue.success(result);
    } catch (e) {
      _historyState = AsyncValue.error(e);
    }

    notifyListeners();
  }

  void _upsertLocalHistory(RideHistoryModel history) {
    final current = rides;

    final index = current.indexWhere((ride) => ride.id == history.id);
    if (index == -1) {
      _historyState = AsyncValue.success(<RideHistoryModel>[
        history,
        ...current,
      ]);
      notifyListeners();
      return;
    }

    final updated = <RideHistoryModel>[...current];
    updated[index] = history;
    _historyState = AsyncValue.success(updated);
    notifyListeners();
  }

  Future<RideHistoryModel?> startRide({
    required String userId,
    required String bikeNumber,
    required String fromStationName,
    required String fromStationAddress,
    double amountPaid = 2.0,
  }) async {
    final startedAtMs = DateTime.now().millisecondsSinceEpoch;
    final history = RideHistoryModel(
      id: '',
      userId: userId,
      bikeNumber: bikeNumber,
      fromStationName: fromStationName,
      fromStationAddress: fromStationAddress,
      startedAtMs: startedAtMs,
      amountPaid: amountPaid,
    );

    final sessionId = await _repository.createRideHistory(history);

    final createdHistory = history.copyWith(id: sessionId);
    _upsertLocalHistory(createdHistory);
    unawaited(fetchHistory());
    return createdHistory;
  }

  Future<void> completeRide({
    required String sessionId,
    required String returnStationName,
    required String returnStationAddress,
    required int durationSeconds,
  }) async {
    final endedAtMs = DateTime.now().millisecondsSinceEpoch;

    await _repository.updateRideHistory(sessionId, {
      RideHistoryDto.returnStationNameKey: returnStationName,
      RideHistoryDto.returnStationAddressKey: returnStationAddress,
      RideHistoryDto.endedAtMsKey: endedAtMs,
      RideHistoryDto.durationSecondsKey: durationSeconds,
    });

    final rides = this.rides;
    RideHistoryModel? currentRide;
    final rideIndex = rides.indexWhere((ride) => ride.id == sessionId);
    if (rideIndex != -1) {
      currentRide = rides[rideIndex];
    }
    if (currentRide != null) {
      _upsertLocalHistory(
        currentRide.copyWith(
          returnStationName: returnStationName,
          returnStationAddress: returnStationAddress,
          endedAtMs: endedAtMs,
          durationSeconds: durationSeconds,
        ),
      );
    }

    unawaited(fetchHistory());
  }
}
