import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/models/user_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';

class UserViewModel extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final authUser = ref.watch(authStateProvider).asData?.value;
    if (authUser == null) return null;
    return ref.read(userRepositoryProvider).getUserProfile(authUser.uid);
  }

  Future<String?> signUp(String email, String password) async {
    state = const AsyncLoading();
    String? uid;
    state = await AsyncValue.guard(() async {
      uid = await ref.read(userRepositoryProvider).signUp(email, password);
      return null;
    });
    return uid;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).login(email, password);
      return null;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).signOut();
      return null;
    });
  }

  Future<void> createUserProfile(UserModel user) async {
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).createUserProfile(user);
      return user;
    });
  }

  Future<void> updateUserProfile(UserModel user) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).updateUserProfile(user);
      return user;
    });
  }

  Future<void> removeActivePass() async {
    final user = state.value;
    if (user == null) return;

    final updatedUser = user.copyWith(
      clearActivePass: true,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).updateUserProfile(updatedUser);
      return updatedUser;
    });
  }

  Future<void> resetPassword(String email) async {
    await ref.read(userRepositoryProvider).resetPassword(email);
  }
}

final userViewModelProvider =
    AsyncNotifierProvider<UserViewModel, UserModel?>(() {
  return UserViewModel();
});
