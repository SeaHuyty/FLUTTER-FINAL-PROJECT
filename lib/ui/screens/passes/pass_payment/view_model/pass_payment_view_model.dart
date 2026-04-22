import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';

class PassPaymentViewModel extends ChangeNotifier {
  PassPaymentViewModel({required this.selectedPass});

  final PassModel? selectedPass;
  DateTime? _expiryDate;
  AsyncValue<void> purchaseState = AsyncValue.success(null);

  PassModel? get pass => selectedPass;
  DateTime? get expiryDate => _expiryDate;
  bool get isSaving => purchaseState.state == AsyncValueState.loading;
  bool get canPay => selectedPass != null;
  String get noPassSelectedMessage => 'No pass selected';
  String get payNowButtonText => 'Pay now';
  String get expiryText {
    final expiry = _expiryDate ?? _projectedExpiryDate;
    if (expiry == null) return 'N/A';
    return DateFormatter.formatPassExpiry(expiry);
  }

  DateTime? get _projectedExpiryDate {
    final pass = selectedPass;
    if (pass == null) return null;
    return DateTime.now().add(calculateDuration(pass.duration));
  }

  Future<void> completePassPurchase(UserViewModel userViewModel) async {
    final pass = selectedPass;
    if (pass == null) return;

    purchaseState = AsyncValue.loading();
    notifyListeners();

    try {
      final expiry = DateTime.now().add(calculateDuration(pass.duration));
      _expiryDate = expiry;

      final user = userViewModel.user;
      if (user != null) {
        final updatedUser = user.copyWith(
          activePassId: pass.id,
          activePassTitle: pass.title,
          activePassExpiry: expiry.toIso8601String(),
        );
        await userViewModel.updateUserProfile(updatedUser);
      }
      purchaseState = AsyncValue.success(null);
    } catch (e) {
      purchaseState = AsyncValue.error(e);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

 Duration calculateDuration(String rawDuration) {
  final parts = rawDuration.toLowerCase().split(' ');
  
  final int value = int.tryParse(parts[0]) ?? 1;
  
    if (rawDuration.contains('year')) {
    return Duration(days: value * 365);

  } else if (rawDuration.contains('month')) {
    return Duration(days: value * 30);

  } else if (rawDuration.contains('week')) {
    return Duration(days: value * 7);

  } else {
    return Duration(days: value);
  }
}
}
