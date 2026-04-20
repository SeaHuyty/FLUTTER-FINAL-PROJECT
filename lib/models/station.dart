import 'package:velo_toulouse_redesign/models/bike.dart';

class StationModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final String address;
  final List<BikeModel> bikes;

  const StationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.address,
    required this.bikes, 
  });

  List<BikeModel> get dockedBikes =>
      bikes.where((b) => b.status == BikeStatus.docked).toList();

  int get availableBikes => dockedBikes.length;
  int get availableSpots => capacity - availableBikes;
}