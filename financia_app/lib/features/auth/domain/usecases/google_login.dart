// lib/features/auth/domain/usecases/google_login.dart

import '../repositories/auth_repository.dart';

class GoogleLogin {
  final AuthRepository repository;

  GoogleLogin(this.repository);

  Future<Map<String, dynamic>> call(String googleToken) async {
    return await repository.googleLogin(googleToken);
  }
}
