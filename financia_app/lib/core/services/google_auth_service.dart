// lib/core/services/google_auth_service.dart
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '821722343026-vaki9d522dh38e6tmpetj8lqd66m7aaq.apps.googleusercontent.com',
    scopes: [
      'email',
    ],
  );

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        // The idToken can be sent to your backend for verification
        return auth.idToken;
      }
    } catch (e) {
      print('Google Sign-In error: $e');
    }
    return null;
  }
}
