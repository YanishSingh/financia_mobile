import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<ProfileEntity> call(
      Map<String, dynamic> profileData, String token) async {
    return await repository.updateProfile(profileData, token);
  }
}
