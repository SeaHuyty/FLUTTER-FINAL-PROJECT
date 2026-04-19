class RideHistoryModel {
  final String id;
  final String userId;
  final String bikeNumber;
  final String fromStationName;
  final String fromStationAddress;
  final String? returnStationName;
  final String? returnStationAddress;
  final int startedAtMs;
  final int? endedAtMs;
  final int? durationSeconds;
  final double amountPaid;

  const RideHistoryModel({
    required this.id,
    required this.userId,
    required this.bikeNumber,
    required this.fromStationName,
    required this.fromStationAddress,
    this.returnStationName,
    this.returnStationAddress,
    required this.startedAtMs,
    this.endedAtMs,
    this.durationSeconds,
    required this.amountPaid,
  });

  RideHistoryModel copyWith({
    String? id,
    String? userId,
    String? bikeNumber,
    String? fromStationName,
    String? fromStationAddress,
    String? returnStationName,
    String? returnStationAddress,
    int? startedAtMs,
    int? endedAtMs,
    int? durationSeconds,
    double? amountPaid,
  }) {
    return RideHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      fromStationName: fromStationName ?? this.fromStationName,
      fromStationAddress: fromStationAddress ?? this.fromStationAddress,
      returnStationName: returnStationName ?? this.returnStationName,
      returnStationAddress: returnStationAddress ?? this.returnStationAddress,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      endedAtMs: endedAtMs ?? this.endedAtMs,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      amountPaid: amountPaid ?? this.amountPaid,
    );
  }
}
