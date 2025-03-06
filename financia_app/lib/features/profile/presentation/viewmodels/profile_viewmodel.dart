import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/update_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final UpdateProfile updateProfileUseCase;
  final ChangePassword changePasswordUseCase;

  ProfileEntity? profile;
  bool isLoading = false;

  ProfileViewModel({
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  });

  Future<ProfileEntity> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await updateProfileUseCase(profileData, token);
      return profile!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(
      Map<String, dynamic> passwordData, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      await changePasswordUseCase(passwordData, token);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
