import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

typedef AuthFormSubmit = void Function(
    String name, String email, String password, File? image);

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final AuthFormSubmit onSubmit;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Helper method to request permission and pick image.
  Future<File?> _pickImageWithPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Camera permission is required.")),
          );
          return null;
        }
      }
    } else if (source == ImageSource.gallery) {
      // On Android, use Permission.photos may not be supported; use storage instead.
      final status = Platform.isAndroid
          ? await Permission.storage.status
          : await Permission.photos.status;
      if (!status.isGranted) {
        final result = Platform.isAndroid
            ? await Permission.storage.request()
            : await Permission.photos.request();
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gallery permission is required.")),
          );
          return null;
        }
      }
    }
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Opens a dialog with options to pick an image.
  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Image'),
        content: const Text('Choose your image source'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final imageFile =
                  await _pickImageWithPermission(ImageSource.camera);
              if (imageFile != null) {
                setState(() {
                  _image = imageFile;
                });
              }
            },
            child: const Text('Use Camera'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final imageFile =
                  await _pickImageWithPermission(ImageSource.gallery);
              if (imageFile != null) {
                setState(() {
                  _image = imageFile;
                });
              }
            },
            child: const Text('Select from Device'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();
    // Pass null for image if it's a login request.
    widget.onSubmit(_name, _email, _password, widget.isLogin ? null : _image);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin)
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/default-profile.png')
                        as ImageProvider,
              ),
            ),
          if (!widget.isLogin) const SizedBox(height: 10),
          if (!widget.isLogin)
            TextFormField(
              key: const ValueKey('name'),
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.trim().length < 4) {
                  return 'Please enter at least 4 characters';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!.trim();
              },
            ),
          TextFormField(
            key: const ValueKey('email'),
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!.trim();
            },
          ),
          TextFormField(
            key: const ValueKey('password'),
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!.trim();
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.isLogin ? 'Login' : 'Sign Up'),
          ),
        ],
      ),
    );
  }
}
