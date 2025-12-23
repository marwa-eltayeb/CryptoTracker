class UserModel {
  final String id;
  final String email;
  final String? username;
  final String? phoneNumber;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.photoUrl,
  });
}
