import 'package:financia_app/features/auth/presentation/pages/login_page.dart';
import 'package:financia_app/features/auth/presentation/pages/signup_page.dart';
import 'package:financia_app/features/main/presentation/pages/main_screen.dart';
import 'package:financia_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:financia_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  // These add transaction routes can be navigated to from within MainScreen pages.
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.splash: (context) => const SplashScreen(),
  Routes.onboarding: (context) => const OnboardingScreen(),
  Routes.login: (context) => const LoginPage(),
  Routes.signup: (context) => const SignupPage(),
  Routes.main: (context) => const MainScreen(),
};
