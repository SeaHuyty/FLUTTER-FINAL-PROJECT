import 'package:firebase_auth/firebase_auth.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_firebase_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/viewmodels/ride_history_viewmodel.dart';

List<SingleChildWidget> get appProviders {
  return [
    Provider<RideHistoryRepository>(
      create: (context) => RideHistoryFirebaseRepository(),
    ),
    ChangeNotifierProvider<RideHistoryViewModel>(
      create: (context) => RideHistoryViewModel(
        repository: context.read<RideHistoryRepository>(),
        auth: FirebaseAuth.instance,
      )..loadHistory(),
    ),
  ];
}
