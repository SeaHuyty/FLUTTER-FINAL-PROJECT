import 'package:velo_toulouse_redesign/models/ride_history.dart';

abstract class RideHistoryRepository {
  Future<String> createRideHistory(RideHistoryModel history);
  Future<void> updateRideHistory(String id, Map<String, dynamic> updates);
  Future<List<RideHistoryModel>> getHistoryForUser(String userId);
}
