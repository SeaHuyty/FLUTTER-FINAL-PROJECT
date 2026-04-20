import 'package:velo_toulouse_redesign/models/user.dart';

abstract class UserRepository {
  Future<String> signUp(String email, String password);
  Future<String> login(String email, String password);
  Future<void> signOut();
  Future<void> createUserProfile(UserModel user);
  Future<void> updateUserProfile(UserModel user);
  Future<UserModel?> getUserProfile(String id);
  Future<void> resetPassword(String email);
}
