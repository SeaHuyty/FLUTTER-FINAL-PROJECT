import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulouse_redesign/data/dtos/user_dto.dart';
import 'package:velo_toulouse_redesign/models/user.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';

class UserFirebaseRepository implements UserRepository {
  final FirebaseAuth _auth;
  final FirebaseDatabase _database;

  UserFirebaseRepository({FirebaseAuth? auth, FirebaseDatabase? database})
    : _auth = auth ?? FirebaseAuth.instance,
      _database = database ?? FirebaseDatabase.instance;

  DatabaseReference _userRef(String uid) => _database.ref('users/$uid');

  @override
  Future<String> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  @override
  Future<String> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _userRef(user.id).set(UserDto.toMap(user));
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _userRef(user.id).update(UserDto.toMap(user));
  }

  @override
  Future<UserModel?> getUserProfile(String id) async {
    final snapshot = await _userRef(id).get();
    if (!snapshot.exists || snapshot.value == null) return null;
    return UserDto.fromSnapshot(id, snapshot.value);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
