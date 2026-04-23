enum BikeStatus { docked, inUse }

class BikeModel {
  final String plateNumber;
  final BikeStatus status;

  const BikeModel({required this.plateNumber, required this.status});

  factory BikeModel.fromMap(Map<String, dynamic> data) {
    return BikeModel(
      plateNumber: data['plate_number'] as String,
      status: BikeStatus.values.byName(data['status'] as String),
    );
  }

  static Map<String, dynamic> bikeToMap(BikeModel bike) {
    return <String, dynamic>{
      'plate_number': bike.plateNumber,
      'status': bike.status.name,
    };
  }
}
