import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/bike_model.dart';

class BikeViewModel extends ChangeNotifier {
  BikeModel? _bike;

  BikeModel? get bike => _bike;

  FutureOr<void> setBike(BikeModel bike) {
    _bike = bike;
    notifyListeners();
  }
}
