import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/pass_booking_view_model.dart';

class PassViewModel extends ChangeNotifier {
  UserViewModel? _userViewModel;
  PassBookingProvider? _bookingProvider;
  DateTime? _expiryDate;

  void updateDependencies(
    UserViewModel userViewModel,
    PassBookingProvider bookingProvider,
  ) {
    _userViewModel = userViewModel;
    _bookingProvider = bookingProvider;
  }

  bool hasActivePass([String? activePassExpiry]) {
    final expiry =
        activePassExpiry ?? _userViewModel?.user?.activePassExpiry;
    return DateFormatter.isFutureDate(expiry);
  }

  Future<void> purchasePass(PassModel pass) async {
    final booking = _bookingProvider;
    if (booking == null) {
      return;
    }

    final now = DateTime.now();
    final expiry = now.add(_durationFromPass(pass.duration));

    booking.setSelectedPass(pass);
    booking.setPurchaseDate(now);

    _expiryDate = expiry;

    final user = _userViewModel?.user;
    if (user != null) {
      final updatedUser = user.copyWith(
        activePassId: pass.id,
        activePassTitle: pass.title,
        activePassExpiry: expiry.toIso8601String(),
      );
      await _userViewModel?.updateUserProfile(updatedUser);
    }

    notifyListeners();
  }

  String getExpiryDate() {
    if (_expiryDate != null) {
      return DateFormatter.formatPassExpiry(_expiryDate!);
    }

    final activePassExpiry = _userViewModel?.user?.activePassExpiry;
    final parsed = DateFormatter.tryParseIsoDate(activePassExpiry);
    if (parsed == null) {
      return 'N/A';
    }

    return DateFormatter.formatPassExpiry(parsed);
  }

  Duration _durationFromPass(String rawDuration) {
    final value = int.tryParse(
          RegExp(r'\d+').firstMatch(rawDuration)?.group(0) ?? '',
        ) ??
        1;

    final duration = rawDuration.toLowerCase();
    if (duration.contains('month')) {
      return Duration(days: value * 30);
    }
    if (duration.contains('week')) {
      return Duration(days: value * 7);
    }
    return Duration(days: value);
  }
}
