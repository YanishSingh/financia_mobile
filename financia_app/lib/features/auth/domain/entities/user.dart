// lib/features/auth/domain/entities/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });
}
