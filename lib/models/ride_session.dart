class RideSession {
  final String? sessionId;
  final String? userId;
  final String? fromStationId;
  final String bikeNumber;
  final String fromStationName;
  final String fromStationAddress;
  final String? returnStationName;
  final String? returnStationAddress;
  final int? startedAtMs;
  final double? amountPaid;

  const RideSession({
    this.sessionId,
    this.userId,
    this.fromStationId,
    required this.bikeNumber,
    required this.fromStationName,
    required this.fromStationAddress,
    this.returnStationName,
    this.returnStationAddress,
    this.startedAtMs,
    this.amountPaid,
  });

  RideSession copyWith({
    String? sessionId,
    String? userId,
    String? fromStationId,
    String? bikeNumber,
    String? fromStationName,
    String? fromStationAddress,
    String? returnStationName,
    String? returnStationAddress,
    int? startedAtMs,
    double? amountPaid,
  }) {
    return RideSession(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      fromStationId: fromStationId ?? this.fromStationId,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      fromStationName: fromStationName ?? this.fromStationName,
      fromStationAddress: fromStationAddress ?? this.fromStationAddress,
      returnStationName: returnStationName ?? this.returnStationName,
      returnStationAddress: returnStationAddress ?? this.returnStationAddress,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      amountPaid: amountPaid ?? this.amountPaid,
    );
  }
}
