import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> updateProfile(
      Map<String, dynamic> profileData, String token);
  Future<void> changePassword(Map<String, dynamic> passwordData, String token);
}
