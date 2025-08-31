// features/auth/data/datasources/auth_remote_data_source.dart
import 'dart:io';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> googleLogin(String googleToken);
}
