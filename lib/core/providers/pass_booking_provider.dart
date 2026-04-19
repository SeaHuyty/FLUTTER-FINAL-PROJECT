import 'package:flutter_riverpod/legacy.dart';

import 'package:velo_toulouse_redesign/models/pass_model.dart';
import '../../data/repositories/passes/pass_repository.dart';
import '../../data/repositories/passes/pass_repository_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPassProvider = StateProvider<PassModel?>((ref) => null);

final  purchaseDateProvider = StateProvider<DateTime?>((ref) => null);

final passRepositoryProvider = Provider<PassRepository>((ref) {
  return PassRepositoryFirebase();
});





