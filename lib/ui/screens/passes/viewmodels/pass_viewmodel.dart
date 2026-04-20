import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository_firebase.dart';
import '../../../../core/providers/pass_booking_provider.dart';

class PassViewModel extends ChangeNotifier {
  PassViewModel({PassRepository? repository})
    : _repository = repository ?? PassRepositoryFirebase() {
    unawaited(fetchPasses());
  }

  final PassRepository _repository;
  UserViewModel? _userViewModel;
  PassBookingProvider? _bookingProvider;

  List<PassModel> _passes = <PassModel>[];
  bool _isLoading = false;
  String? _error;

  List<PassModel> get passes => _passes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateDependencies(
    UserViewModel userViewModel,
    PassBookingProvider bookingProvider,
  ) {
    _userViewModel = userViewModel;
    _bookingProvider = bookingProvider;
  }

  Future<void> fetchPasses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _passes = await _repository.getAvailablePasses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasActivePass() {
    final user = _userViewModel?.user;
    if (user?.activePassExpiry == null) return false;

    try {
      final cleanDate = user!.activePassExpiry!.replaceFirst('Le. ', '');
      final expiryDate = DateFormat('d / MMMM / y').parse(cleanDate);
      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String getExpiryDate() {
    final selectedPass = _bookingProvider?.selectedPass;
    if (selectedPass == null) return '';

    final now = DateTime.now();
    DateTime expiry;
    final duration = selectedPass.duration.toLowerCase();

    if (duration.contains('24 hours') || duration.contains('1 day')) {
      expiry = now.add(const Duration(days: 1));
    } else if (duration.contains('7 days')) {
      expiry = now.add(const Duration(days: 7));
    } else if (duration.contains('30 days')) {
      expiry = now.add(const Duration(days: 30));
    } else if (duration.contains('1 year')) {
      expiry = now.add(const Duration(days: 365));
    } else {
      expiry = now.add(const Duration(days: 1));
    }

    return 'Le. ${expiry.day} / ${DateFormat('MMMM').format(expiry)} / ${expiry.year}';
  }

  Future<void> purchasePass(PassModel pass) async {
    final expiryDate = getExpiryDate();
    final user = _userViewModel?.user;

    if (user != null) {
      final updatedUser = user.copyWith(
        activePassId: pass.id,
        activePassTitle: pass.title,
        activePassExpiry: expiryDate,
      );
      await _userViewModel?.updateUserProfile(updatedUser);
    }
  }
}
