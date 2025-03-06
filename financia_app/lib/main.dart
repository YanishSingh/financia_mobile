import 'package:financia_app/core/constants/app_constants.dart';
import 'package:financia_app/core/utils/shake_detector.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/budget/presentation/viewmodels/budget_viewmodel.dart';
import 'features/main/presentation/pages/main_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'features/transaction/presentation/viewmodels/transaction_viewmodel.dart';
import 'injection_container.dart' as di;

/// Checks if fingerprint authentication is enabled and, if so, prompts the user.
Future<bool> _authenticateIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  bool enabled = prefs.getBool('fingerprintEnabled') ?? false;
  if (enabled) {
    final localAuth = LocalAuthentication();
    bool authenticated = await localAuth.authenticate(
      localizedReason: "Please authenticate to access the app",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    return authenticated;
  }
  return true;
}

/// For this solution, the initial route is always the splash screen.
Future<String> getInitialRoute() async {
  return '/splash';
}

/// Displays a confirmation dialog for logout.
Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Yes"),
            ),
          ],
        ),
      ) ??
      false;
}

/// A wrapper widget that listens for shake events to trigger logout.
class ShakeLogoutWrapper extends StatefulWidget {
  final Widget child;
  const ShakeLogoutWrapper({super.key, required this.child});

  @override
  _ShakeLogoutWrapperState createState() => _ShakeLogoutWrapperState();
}

class _ShakeLogoutWrapperState extends State<ShakeLogoutWrapper> {
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(
      onShake: _handleShake,
    );
    _shakeDetector.startListening();
  }

  Future<void> _handleShake() async {
    bool confirmed = await showLogoutConfirmationDialog(context);
    if (confirmed) {
      Navigator.of(context).pushReplacementNamed('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out due to shake gesture'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  bool authResult = await _authenticateIfNeeded();
  if (!authResult) {
    // Optionally handle authentication failure.
    return;
  }
  String initialRoute = await getInitialRoute();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<TransactionViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<BudgetViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileViewModel>()),
      ],
      child: MyAppWithRoutes(initialRoute: initialRoute),
    ),
  );
}

/// Wraps MyApp with MaterialApp, includes ShakeLogoutWrapper on main screen, and defines routes.
class MyAppWithRoutes extends StatelessWidget {
  final String initialRoute;
  const MyAppWithRoutes({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => ShakeLogoutWrapper(child: const MainScreen()),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginPage());
      },
    );
  }
}
