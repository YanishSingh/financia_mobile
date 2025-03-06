// lib/features/auth/domain/usecases/signup.dart

import 'dart:io';

import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<Map<String, dynamic>> call(
      String name, String email, String password, File? image) async {
    return await repository.signup(name, email, password, image);
  }
}
