import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthProvider extends ChangeNotifier {
  final AuthViewModel authViewModel;

  AuthProvider(this.authViewModel);

  bool get isLoading => authViewModel.isLoading;
  String? get errorMessage => authViewModel.errorMessage;

  Future<void> login(String email, String password) async {
    await authViewModel.login(email, password);
    notifyListeners();
  }

  Future<void> signup(
      String name, String email, String password, dynamic image) async {
    await authViewModel.signup(name, email, password, image);
    notifyListeners();
  }

  Future<void> googleLogin(String googleToken) async {
    await authViewModel.googleLogin(googleToken);
    notifyListeners();
  }
}
