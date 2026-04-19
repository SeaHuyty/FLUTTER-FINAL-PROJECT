import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/models/bike_model.dart';

class BikeViewModel extends AsyncNotifier<BikeModel> {
  @override
  FutureOr<BikeModel> build() {
    return Completer<BikeModel>().future;
  }
}

final bikeViewModelProvider = AsyncNotifierProvider<BikeViewModel, BikeModel>(() {
  return BikeViewModel();
});