// lib/features/auth/domain/usecases/auth_usecases.dart
import 'dart:io';

import '../repositories/auth_repository.dart';

abstract class AuthUseCases {
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> googleLogin(String googleToken);
}

class AuthUseCasesImpl implements AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCasesImpl({required this.authRepository});

  @override
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image) {
    return authRepository.signup(name, email, password, image);
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) {
    return authRepository.login(email, password);
  }

  @override
  Future<Map<String, dynamic>> googleLogin(String googleToken) {
    return authRepository.googleLogin(googleToken);
  }
}
