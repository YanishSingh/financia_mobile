import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> updateProfile(
      Map<String, dynamic> profileData, String token);
  Future<void> changePassword(Map<String, dynamic> passwordData, String token);
}
