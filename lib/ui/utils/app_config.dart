import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get mapboxToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

  static String get firebaseUrl => dotenv.env['FIREBASE_URL'] ?? '';

  static String get storageBucketUrl => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  static String get mapboxTileUrl =>
      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}?access_token=$mapboxToken';

  static String get mapboxSatelliteUrl =>
      'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/256/{z}/{x}/{y}?access_token=$mapboxToken';

}
