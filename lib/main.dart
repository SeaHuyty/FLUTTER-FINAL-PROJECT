import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/core/utils/firebase_options.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/pass_booking_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/login_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/main_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/splash/splash_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/viewmodels/pass_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/viewmodels/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/viewmodels/ride_history_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final token = AppConfig.mapboxToken;
  if (token.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<PassBookingProvider>(
          create: (_) => PassBookingProvider(),
        ),
        ChangeNotifierProvider<RideSessionProvider>(
          create: (_) => RideSessionProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserViewModel>(
          create: (_) => UserViewModel(),
          update: (_, authProvider, userViewModel) {
            final vm = userViewModel ?? UserViewModel();
            vm.onAuthUserChanged(authProvider.user);
            return vm;
          },
        ),
        ChangeNotifierProxyProvider2<
          UserViewModel,
          PassBookingProvider,
          PassViewModel
        >(
          create: (_) => PassViewModel(),
          update: (_, userViewModel, bookingProvider, passViewModel) {
            final vm = passViewModel ?? PassViewModel();
            vm.updateDependencies(userViewModel, bookingProvider);
            return vm;
          },
        ),
        ChangeNotifierProvider<StationViewModel>(
          create: (_) => StationViewModel(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RideHistoryViewModel>(
          create: (_) => RideHistoryViewModel(),
          update: (_, authProvider, rideHistoryViewModel) {
            final vm = rideHistoryViewModel ?? RideHistoryViewModel();
            vm.onAuthUserChanged(authProvider.user);
            return vm;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Velo Toulouse',
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>();
    if (authState.isLoading) {
      return const SplashScreen();
    }
    return authState.isAuthenticated ? const MainScreen() : const LoginScreen();
  }
}
