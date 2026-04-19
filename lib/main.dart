import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:velo_toulouse_redesign/core/providers/app_providers.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/core/utils/firebase_options.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/login_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final token = AppConfig.mapboxToken;
  if (token.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }
  runApp(
    provider.MultiProvider(
      providers: appProviders,
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velo Toulouse',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const LoginScreen(),
      data: (user) => user != null ? const MainScreen() : const LoginScreen(),
    );
  }
}
