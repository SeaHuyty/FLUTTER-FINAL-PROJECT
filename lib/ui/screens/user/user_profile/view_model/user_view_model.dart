import 'package:flutter/foundation.dart';
import 'package:velo_toulouse_redesign/models/user.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel({UserRepository? repository})
    : _repository = repository ?? UserFirebaseRepository();

  final UserRepository _repository;
  String? _authUid;

  AsyncValue<UserModel?> _userState = AsyncValue.success(null);

  AsyncValue<UserModel?> get userState => _userState;
  UserModel? get user => _userState.data;
  bool get isLoading => _userState.state == AsyncValueState.loading;
  String? get error => _userState.state == AsyncValueState.error
      ? _userState.error.toString()
      : null;
  bool get hasError => _userState.state == AsyncValueState.error;

  Future<void> onAuthUserChanged(User? authUser) async {
    final newUid = authUser?.uid;
    if (_authUid == newUid) return;
    _authUid = newUid;

    if (newUid == null) {
      _userState = AsyncValue.success(null);
      notifyListeners();
      return;
    }

    await loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    if (_authUid == null) {
      _userState = AsyncValue.success(null);
      notifyListeners();
      return;
    }

    _setLoading();
    try {
      final loadedUser = await _repository.getUserProfile(_authUid!);
      _setSuccess(loadedUser);
    } catch (e) {
      _setError(e);
    }
  }

  Future<String?> signUp(String email, String password) async {
    _setLoading();
    String? uid;
    try {
      uid = await _repository.signUp(email, password);
      _setSuccess(user);
    } catch (e) {
      _setError(e);
    }
    return uid;
  }

  Future<void> login(String email, String password) async {
    _setLoading();
    try {
      await _repository.login(email, password);
      _setSuccess(user);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> signOut() async {
    _setLoading();
    try {
      await _repository.signOut();
      _setSuccess(null);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> createUserProfile(UserModel user) async {
    _setLoading();
    try {
      await _repository.createUserProfile(user);
      _setSuccess(user);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    _setLoading();
    try {
      await _repository.updateUserProfile(user);
      _setSuccess(user);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> removeActivePass() async {
    final user = this.user;
    if (user == null) return;

    final updatedUser = user.copyWith(clearActivePass: true);

    _setLoading();
    try {
      await _repository.updateUserProfile(updatedUser);
      _setSuccess(updatedUser);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    await _repository.resetPassword(email);
  }

  void _setLoading() {
    _userState = AsyncValue.loading();
    notifyListeners();
  }

  void _setSuccess(UserModel? user) {
    _userState = AsyncValue.success(user);
    notifyListeners();
  }

  void _setError(Object error) {
    _userState = AsyncValue.error(error);
    notifyListeners();
  }
}
