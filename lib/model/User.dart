class User {
  final String email;
  final String username;
  final bool isValid;
  final DateTime createdAt;

  User({
    required this.email,
    required this.username,
    required this.isValid,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      username: json['username'],
      isValid: json['is_valid'] == 1,
      createdAt: DateTime.parse(json['created_at'])
  );
}
