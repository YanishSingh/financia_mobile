import '../repositories/profile_repository.dart';

class ChangePassword {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  Future<void> call(Map<String, dynamic> passwordData, String token) async {
    return await repository.changePassword(passwordData, token);
  }
}
