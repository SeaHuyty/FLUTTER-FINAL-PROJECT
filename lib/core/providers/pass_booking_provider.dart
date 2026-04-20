import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';

class PassBookingProvider extends ChangeNotifier {
  PassModel? _selectedPass;
  DateTime? _purchaseDate;

  PassModel? get selectedPass => _selectedPass;
  DateTime? get purchaseDate => _purchaseDate;

  void setSelectedPass(PassModel? pass) {
    _selectedPass = pass;
    notifyListeners();
  }

  void setPurchaseDate(DateTime? date) {
    _purchaseDate = date;
    notifyListeners();
  }

  void clear() {
    _selectedPass = null;
    _purchaseDate = null;
    notifyListeners();
  }
}
