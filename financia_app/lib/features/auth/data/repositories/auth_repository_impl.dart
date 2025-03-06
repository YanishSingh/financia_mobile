// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:io';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image) {
    return remoteDataSource.signup(name, email, password, image);
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<Map<String, dynamic>> googleLogin(String googleToken) {
    return remoteDataSource.googleLogin(googleToken);
  }
}
