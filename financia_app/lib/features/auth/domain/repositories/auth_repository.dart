// lib/features/auth/domain/repositories/auth_repository.dart
import 'dart:io';

abstract class AuthRepository {
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> googleLogin(String googleToken);
}
