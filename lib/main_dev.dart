import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository_firebase.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_firebase_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';
import 'package:velo_toulouse_redesign/main_common.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/view_model/ride_history_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/view_model/auth_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';
import 'package:velo_toulouse_redesign/ui/utils/firebase_options.dart';


final List<SingleChildWidget> devProviders = [
  // Repositories
  Provider<UserRepository>(create: (_) => UserFirebaseRepository()),
  Provider<PassRepository>(create: (_) => PassRepositoryFirebase()),
  Provider<RideHistoryRepository>(
    create: (_) => RideHistoryFirebaseRepository(),
  ),
  Provider<StationRepository>(create: (_) => StationRepositoryFirebase()),

  // ChangeNotifierProviders
  ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  ChangeNotifierProvider<RideSessionViewModel>(create: (_) => RideSessionViewModel()),

  // ViewModels
  ChangeNotifierProvider<UserViewModel>(
    create: (context) {
      final vm = UserViewModel(
        repository: context.read<UserRepository>(),
      );
      vm.onAuthUserChanged(context.read<AuthViewModel>().user);
      return vm;
    },
  ),

  ChangeNotifierProvider<RideHistoryViewModel>(
    create: (context) {
      final vm = RideHistoryViewModel(
        repository: context.read<RideHistoryRepository>(),
      );
      vm.onAuthUserChanged(context.read<AuthViewModel>().user);
      return vm;
    },
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  if (AppConfig.mapboxToken.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }

  runApp(mainCommon(devProviders));
}
