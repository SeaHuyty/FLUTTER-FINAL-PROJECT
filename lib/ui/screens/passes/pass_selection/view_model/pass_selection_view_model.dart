import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';

class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository repository;
  bool _isDisposed = false;

  PassSelectionViewModel(this.repository);

  AsyncValue<List<PassModel>> passes = AsyncValue.loading();
  PassModel? selectedPass;

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<void> fetchPasses() async {
    passes = AsyncValue.loading();
    _safeNotify();

    try {
      final result = await repository.getPasses();
      passes = AsyncValue.success(result);
    } catch (e) {
      passes = AsyncValue.error(e);
    }

    _safeNotify();
  }

  bool hasActivePass(String? activePassExpiry) {
    return DateFormatter.isFutureDate(activePassExpiry);
  }

  void selectPass(PassModel pass) {
    selectedPass = pass;
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
