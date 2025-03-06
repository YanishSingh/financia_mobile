import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    return await remoteDataSource.updateProfile(profileData, token);
  }

  @override
  Future<void> changePassword(
      Map<String, dynamic> passwordData, String token) async {
    return await remoteDataSource.changePassword(passwordData, token);
  }
}
