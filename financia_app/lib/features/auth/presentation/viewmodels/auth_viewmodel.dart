import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/auth_usecases.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthUseCases authUseCases;
  bool isLoading = false;
  String? errorMessage;
  String? token;
  Map<String, dynamic>? user; // Stores user details

  AuthViewModel(this.authUseCases);

  Future<Map<String, dynamic>?> signup(
      String name, String email, String password, File? image) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await authUseCases.signup(name, email, password, image);
      if (response.containsKey('token')) {
        token = response['token'];
        user = response['user']; // Save the user info from the response
        await _saveToken(token!);
      }
      return response;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await authUseCases.login(email, password);
      if (response.containsKey('token')) {
        token = response['token'];
        user = response['user']; // Save the user info from the response
        await _saveToken(token!);
      }
      return response;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> googleLogin(String googleToken) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await authUseCases.googleLogin(googleToken);
      if (response.containsKey('token')) {
        token = response['token'];
        user = response['user']; // Save the user info from the response
        await _saveToken(token!);
      }
      return response;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// **New Method to Update User Data in Real-Time**
  void setUser(Map<String, dynamic> newUserData) {
    user = newUserData;
    notifyListeners(); // This triggers UI updates
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}
