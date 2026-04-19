import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/data/dtos/ride_history_dto.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse_redesign/models/ride_history_model.dart';

class RideHistoryViewModel extends ChangeNotifier {
  RideHistoryViewModel({required this.repository, required this.auth});

  final RideHistoryRepository repository;
  final FirebaseAuth auth;

  List<RideHistoryModel> _history = <RideHistoryModel>[];
  bool _isLoading = false;
  Object? _error;

  List<RideHistoryModel> get history => _history;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> loadHistory() async {
    final authUser = auth.currentUser;
    if (authUser == null) {
      _history = <RideHistoryModel>[];
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _history = await repository.getHistoryForUser(authUser.uid);
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _upsertLocalHistory(RideHistoryModel history) {
    final current = _history;

    final index = current.indexWhere((ride) => ride.id == history.id);
    if (index == -1) {
      _history = <RideHistoryModel>[history, ...current];
      notifyListeners();
      return;
    }

    final updated = <RideHistoryModel>[...current];
    updated[index] = history;
    _history = updated;
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

    final sessionId = await repository.createRideHistory(history);

    final createdHistory = history.copyWith(id: sessionId);
    _upsertLocalHistory(createdHistory);
    return createdHistory;
  }

  Future<void> completeRide({
    required String sessionId,
    required String returnStationName,
    required String returnStationAddress,
    required int durationSeconds,
  }) async {
    final endedAtMs = DateTime.now().millisecondsSinceEpoch;

    await repository.updateRideHistory(sessionId, {
      RideHistoryDto.returnStationNameKey: returnStationName,
      RideHistoryDto.returnStationAddressKey: returnStationAddress,
      RideHistoryDto.endedAtMsKey: endedAtMs,
      RideHistoryDto.durationSecondsKey: durationSeconds,
    });

    final rides = _history;
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
  }
}
