import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/user.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel({UserRepository? repository})
    : _repository = repository ?? UserFirebaseRepository();

  final UserRepository _repository;
  String? _authUid;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> onAuthUserChanged(User? authUser) async {
    final newUid = authUser?.uid;
    if (_authUid == newUid) return;
    _authUid = newUid;

    if (newUid == null) {
      _user = null;
      _isLoading = false;
      _error = null;
      notifyListeners();
      return;
    }

    await loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    if (_authUid == null) {
      _user = null;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _user = await _repository.getUserProfile(_authUid!);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signUp(String email, String password) async {
    _setLoading(true);
    String? uid;
    try {
      uid = await _repository.signUp(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    return uid;
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _repository.login(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
      _error = null;
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createUserProfile(UserModel user) async {
    _setLoading(true);
    try {
      await _repository.createUserProfile(user);
      _user = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    _setLoading(true);
    try {
      await _repository.updateUserProfile(user);
      _user = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeActivePass() async {
    final user = _user;
    if (user == null) return;

    final updatedUser = user.copyWith(clearActivePass: true);

    _setLoading(true);
    try {
      await _repository.updateUserProfile(updatedUser);
      _user = updatedUser;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    await _repository.resetPassword(email);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
