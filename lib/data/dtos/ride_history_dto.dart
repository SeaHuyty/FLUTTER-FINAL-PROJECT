import 'package:velo_toulouse_redesign/models/ride_history_model.dart';

class RideHistoryDto {
  static const String userIdKey = 'user_id';
  static const String bikeNumberKey = 'bike_number';
  static const String fromStationNameKey = 'from_station_name';
  static const String fromStationAddressKey = 'from_station_address';
  static const String returnStationNameKey = 'return_station_name';
  static const String returnStationAddressKey = 'return_station_address';
  static const String startedAtMsKey = 'started_at_ms';
  static const String endedAtMsKey = 'ended_at_ms';
  static const String durationSecondsKey = 'duration_seconds';
  static const String amountPaidKey = 'amount_paid';

  static RideHistoryModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    return RideHistoryModel(
      id: key,
      userId: data[userIdKey]?.toString() ?? '',
      bikeNumber: data[bikeNumberKey]?.toString() ?? '',
      fromStationName: data[fromStationNameKey]?.toString() ?? '',
      fromStationAddress: data[fromStationAddressKey]?.toString() ?? '',
      returnStationName: data[returnStationNameKey]?.toString(),
      returnStationAddress: data[returnStationAddressKey]?.toString(),
      startedAtMs: (data[startedAtMsKey] as num?)?.toInt() ?? 0,
      endedAtMs: (data[endedAtMsKey] as num?)?.toInt(),
      durationSeconds: (data[durationSecondsKey] as num?)?.toInt(),
      amountPaid: (data[amountPaidKey] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Map<String, dynamic> toMap(RideHistoryModel history) {
    return {
      userIdKey: history.userId,
      bikeNumberKey: history.bikeNumber,
      fromStationNameKey: history.fromStationName,
      fromStationAddressKey: history.fromStationAddress,
      returnStationNameKey: history.returnStationName,
      returnStationAddressKey: history.returnStationAddress,
      startedAtMsKey: history.startedAtMs,
      endedAtMsKey: history.endedAtMs,
      durationSecondsKey: history.durationSeconds,
      amountPaidKey: history.amountPaid,
    };
  }
}
