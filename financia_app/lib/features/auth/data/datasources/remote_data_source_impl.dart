// features/auth/data/datasources/remote_data_source_impl.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'auth_remote_data_source.dart';

class RemoteDataSourceImpl implements AuthRemoteDataSource {
  final String baseUrl;

  RemoteDataSourceImpl({this.baseUrl = 'http://192.168.1.65:5000'});
  // RemoteDataSourceImpl({this.baseUrl = 'http://10.0.2.2:5000'});

  @override
  Future<Map<String, dynamic>> signup(
      String name, String email, String password, File? image) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password;

    if (image != null) {
      // Attach file. Make sure the field name matches what your backend expects.
      request.files
          .add(await http.MultipartFile.fromPath('profileImage', image.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Signup failed: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> googleLogin(String googleToken) async {
    final uri = Uri.parse('$baseUrl/api/auth/google-login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': googleToken}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Google login failed: ${response.body}');
    }
  }
}
