import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/data/dtos/ride_history_dto.dart';
import 'package:velo_toulouse_redesign/models/ride_history_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';

class RideHistoryFirebaseRepository implements RideHistoryRepository {
  final FirebaseDatabase _database;

  RideHistoryFirebaseRepository({FirebaseDatabase? database})
    : _database = database ?? FirebaseDatabase.instance;

  DatabaseReference get _historyRef => _database.ref('ride_sessions');

  @override
  Future<String> createRideHistory(RideHistoryModel history) async {
    final newRef = _historyRef.push();
    await newRef.set(RideHistoryDto.toMap(history));
    final key = newRef.key;
    if (key == null) {
      throw StateError('Failed to create ride history session id');
    }
    return key;
  }

  @override
  Future<void> updateRideHistory(
    String id,
    Map<String, dynamic> updates,
  ) async {
    await _historyRef.child(id).update(updates);
  }

  @override
  Future<List<RideHistoryModel>> getHistoryForUser(String userId) async {
    final snapshot = await _historyRef
        .orderByChild(RideHistoryDto.userIdKey)
        .equalTo(userId)
        .get();

    if (!snapshot.exists || snapshot.value == null) return <RideHistoryModel>[];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries
        .map((e) => RideHistoryDto.fromSnapshot(e.key, e.value))
        .toList();
  }
}

final rideHistoryRepositoryProvider = Provider<RideHistoryRepository>((ref) {
  return RideHistoryFirebaseRepository();
});
