// lib/core/constants/app_constants.dart
import 'dart:io';

class AppConstants {
  // App Information
  static const String appName = 'Financia';

  // Backend URLs
  static const String _backendUrlAndroid = 'http://192.168.1.65:5000';
  // static const String _backendUrlAndroid = 'http://10.0.2.2:5000';
  static const String _backendUrlIOS = 'http://localhost:5000';

  /// Returns the base URL for the backend depending on the platform.
  static String get baseUrl {
    if (Platform.isAndroid) {
      return _backendUrlAndroid;
    } else {
      return _backendUrlIOS;
    }
  }

  // Other constants if needed.
  static const int apiTimeout = 5000;
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String transactionsEndpoint = '/api/transactions';
}
