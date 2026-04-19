import 'package:velo_toulouse_redesign/models/bike_model.dart';

class BikeDto {
  static const String plateNumber = 'plate_number';
  static const String status = 'status';

  static BikeModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    final statusStr = data[status]?.toString() ?? 'docked';

    return BikeModel(
      plateNumber: data[plateNumber]?.toString() ?? '',
      status: BikeStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => BikeStatus.docked,
      ),
    );
  }
}