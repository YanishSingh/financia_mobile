import 'dart:io';

import 'package:financia_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

// Helper function to show logout confirmation dialog.
Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Yes"),
            ),
          ],
        ),
      ) ??
      false;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImageFile;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false; // Controls whether password is visible
  bool _isEditing = false; // Toggles edit mode
  bool _fingerprintEnabled = false; // Fingerprint protection setting

  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    _usernameController =
        TextEditingController(text: authVM.user?['name'] ?? '');
    _emailController = TextEditingController(text: authVM.user?['email'] ?? '');
    _passwordController = TextEditingController(text: '********');
    _loadFingerprintSetting();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadFingerprintSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fingerprintEnabled = prefs.getBool('fingerprintEnabled') ?? false;
    });
  }

  Future<void> _setFingerprintEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fingerprintEnabled', value);
    setState(() {
      _fingerprintEnabled = value;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    // Request permission before picking an image.
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Camera permission is required.")),
          );
          return;
        }
      }
    } else if (source == ImageSource.gallery) {
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gallery permission is required.")),
          );
          return;
        }
      }
    }
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Updates the profile on the backend.
  /// Uses a multipart request in the data layer if a new image file is selected.
  Future<void> _updateProfile() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final token = await authVM.getToken();
    Map<String, dynamic> data = {
      'name': _usernameController.text,
      'profileImage': _profileImageFile != null ? _profileImageFile!.path : '',
    };
    try {
      final updatedProfile = await profileVM.updateProfile(data, token!);
      debugPrint(
          'Updated profile image filename: ${updatedProfile.profileImage}');
      authVM.setUser({
        'name': updatedProfile.name,
        'email': updatedProfile.email,
        'profileImage': updatedProfile.profileImage,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isEditing = false;
        _profileImageFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    }
  }

  void _showPasswordChangeDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              final authVM = Provider.of<AuthViewModel>(context, listen: false);
              final profileVM =
                  Provider.of<ProfileViewModel>(context, listen: false);
              final token = await authVM.getToken();
              try {
                await profileVM.changePassword({
                  'oldPassword': oldPasswordController.text,
                  'newPassword': newPasswordController.text,
                }, token!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _enableFingerprintProtection() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Fingerprint Protection'),
        content: const Text('Do you want to enable fingerprint security?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Confirm fingerprint to enable security',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          await _setFingerprintEnabled(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint protection enabled'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _logout() async {
    bool confirmed = await showLogoutConfirmationDialog(context);
    if (confirmed) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      // Clear user data if necessary.
      authVM.setUser({});
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    String? imageUrl;
    if (authVM.user != null) {
      final String filename = authVM.user!['profileImage'] ?? '';
      if (filename.isNotEmpty) {
        imageUrl = '${AppConstants.baseUrl}/uploads/$filename';
        debugPrint('Constructed image URL: $imageUrl');
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          // Edit icon toggles edit mode or saves profile if in edit mode.
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Optionally refresh profile data from the backend.
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture with update option.
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _showImageSourceOptions : null,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImageFile != null
                          ? FileImage(_profileImageFile!)
                          : (imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage(
                                      'assets/default-profile.png'))
                              as ImageProvider,
                    ),
                  ),
                  if (_isEditing && _profileImageFile != null)
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: _updateProfile,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Fingerprint Protection Toggle (only when not editing).
              if (!_isEditing)
                SwitchListTile(
                  title: const Text("Enable Fingerprint Protection"),
                  value: _fingerprintEnabled,
                  onChanged: (bool value) async {
                    if (value) {
                      await _enableFingerprintProtection();
                    } else {
                      await _setFingerprintEnabled(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fingerprint protection disabled"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                ),
              const SizedBox(height: 16),
              // Username Field: Editable in edit mode.
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  suffixIcon: _isEditing
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {}, // Field is directly editable.
                        )
                      : null,
                ),
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 16),
              // Email Field: Always read-only.
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Password Field: Masked placeholder with toggle and edit button.
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      if (_isEditing)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _showPasswordChangeDialog,
                        ),
                    ],
                  ),
                ),
                obscureText: !_passwordVisible,
                readOnly: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
