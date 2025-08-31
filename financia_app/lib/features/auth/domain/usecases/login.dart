// lib/features/auth/domain/usecases/login.dart

import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Map<String, dynamic>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
