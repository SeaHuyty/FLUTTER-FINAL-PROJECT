abstract class BikeRepository {
  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  });

  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  });
}