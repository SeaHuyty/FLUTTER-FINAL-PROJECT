import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';

class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository repository;

  PassSelectionViewModel(this.repository);

  Future<void> fetchPasses() async {
    passes = AsyncValue.loading();
    notifyListeners();

    try {
      final result = await repository.getPasses();
      passes = AsyncValue.success(result);
    } catch (e) {
      passes = AsyncValue.error(e);
    }
    notifyListeners();
  }

  AsyncValue<List<PassModel>> passes = AsyncValue.loading();
  PassModel? selectedPass;

  void selectPass(PassModel pass) {
    selectedPass = pass;
    notifyListeners();
  }

  void clearSelection() {
    selectedPass = null;
    notifyListeners();
  }

  bool hasActivePass(String? activePassExpiry) {
    return DateFormatter.isFutureDate(activePassExpiry);
  }
}
