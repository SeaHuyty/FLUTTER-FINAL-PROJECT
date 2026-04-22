import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';

class PassPaymentViewModel extends ChangeNotifier {
	final PassModel? initialSelectedPass;
	DateTime? _expiryDate;

	PassPaymentViewModel({required this.initialSelectedPass});

	AsyncValue<PassModel?> selectedPassState = AsyncValue.success(null);

	PassModel? get selectedPass => selectedPassState.data;
	DateTime? get expiryDate => _expiryDate;
	bool get isLoading => selectedPassState.state == AsyncValueState.loading;
	bool get hasError => selectedPassState.state == AsyncValueState.error;
	bool get canPay => selectedPass != null;

	void loadSelectedPass() {
		selectedPassState = AsyncValue.success(initialSelectedPass);
		notifyListeners();
	}

	Future<void> completePassPurchase(UserViewModel userViewModel) async {
		final pass = selectedPass;
		if (pass == null) return;

		final now = DateTime.now();
		final expiry = now.add(_durationFromPass(pass.duration));
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

		notifyListeners();
	}

	String getExpiryDate([String? activePassExpiry]) {
		if (_expiryDate != null) {
			return DateFormatter.formatPassExpiry(_expiryDate!);
		}

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
    if (duration.contains('year')) {
			return Duration(days: value * 365);
		}
		return Duration(days: value);
	}
}
