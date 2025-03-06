import 'dart:convert';

import 'package:financia_app/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    // Check if a profile image file path is provided.
    if (profileData['profileImage'] != null &&
        (profileData['profileImage'] as String).isNotEmpty) {
      // Use multipart request to send the file.
      var request = http.MultipartRequest(
          'PUT', Uri.parse('${AppConstants.baseUrl}/api/auth/update-profile'));
      request.headers['Authorization'] = 'Bearer $token';
      // Add the non-file field(s)
      request.fields['name'] = profileData['name'];
      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath(
          'profileImage', profileData['profileImage']));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } else {
      // No file provided, send as JSON.
      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}/api/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    }
  }

  @override
  Future<void> changePassword(
      Map<String, dynamic> passwordData, String token) async {
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(passwordData),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to change password: ${response.body}');
    }
  }
}
