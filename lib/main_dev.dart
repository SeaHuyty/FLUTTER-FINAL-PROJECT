import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository_firebase.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_firebase_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';
import 'package:velo_toulouse_redesign/main_common.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/view_model/pass_payment_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/view_model/pass_selection_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/view_model/pass_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/view_model/ride_history_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/utils/app_config.dart';
import 'package:velo_toulouse_redesign/ui/utils/firebase_options.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/view_model/auth_view_model.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/pass_booking_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';

final List<SingleChildWidget> devProviders = [
	Provider<UserRepository>(create: (_) => UserFirebaseRepository()),
	Provider<PassRepository>(create: (_) => PassRepositoryFirebase()),
	Provider<RideHistoryRepository>(
		create: (_) => RideHistoryFirebaseRepository(),
	),
	ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
	ChangeNotifierProvider<PassBookingProvider>(create: (_) => PassBookingProvider()),
	ChangeNotifierProvider<RideSessionViewModel>(create: (_) => RideSessionViewModel()),
	ChangeNotifierProvider<MapViewModel>(create: (_) => MapViewModel()),
	ChangeNotifierProvider<PassSelectionViewModel>(
		create: (context) => PassSelectionViewModel(
			context.read<PassRepository>(),
		),
	),
	ChangeNotifierProxyProvider<PassBookingProvider, PassPaymentViewModel>(
		create: (context) => PassPaymentViewModel(
			selectedPass: context.read<PassBookingProvider>().selectedPass,
		),
		update: (_, bookingProvider, passPaymentViewModel) {
			return PassPaymentViewModel(
				selectedPass: bookingProvider.selectedPass,
			);
		},
	),
	ChangeNotifierProxyProvider2<UserRepository, AuthViewModel, UserViewModel>(
		create: (context) => UserViewModel(repository: context.read<UserRepository>()),
		update: (context, userRepository, authProvider, userViewModel) {
			final vm =
					userViewModel ?? UserViewModel(repository: userRepository);
			vm.onAuthUserChanged(authProvider.user);
			return vm;
		},
	),
	ChangeNotifierProxyProvider2<UserViewModel, PassBookingProvider, PassViewModel>(
		create: (_) => PassViewModel(),
		update: (_, userViewModel, bookingProvider, passViewModel) {
			final vm = passViewModel ?? PassViewModel();
			vm.updateDependencies(userViewModel, bookingProvider);
			return vm;
		},
	),
	ChangeNotifierProxyProvider2<RideHistoryRepository, AuthViewModel, RideHistoryViewModel>(
		create: (context) => RideHistoryViewModel(
			repository: context.read<RideHistoryRepository>(),
		),
		update: (context, historyRepository, authProvider, rideHistoryViewModel) {
			final vm =
					rideHistoryViewModel ??
					RideHistoryViewModel(repository: historyRepository);
			vm.onAuthUserChanged(authProvider.user);
			return vm;
		},
	),
];

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await dotenv.load();
	await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

	if (AppConfig.mapboxToken.isEmpty) {
		throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
	}

	runApp(mainCommon(devProviders));
}
