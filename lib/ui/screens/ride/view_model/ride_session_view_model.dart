import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/ride_session.dart';

class RideSessionViewModel extends ChangeNotifier {
  RideSession? _session;

  RideSession? get session => _session;

  void setSession(RideSession? session) {
    _session = session;
    notifyListeners();
  }

  void clear() {
    _session = null;
    notifyListeners();
  }
}
