class User {
  final String id;
  final String email;
  final String name;
  final String? lastName;
  final String? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.lastName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['userId'] ?? json['id'] ?? json['_id'] ?? '').toString(),
        email: json['email']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        lastName: json['lastName']?.toString(),
        profilePicture: json['profilePicture']?.toString(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}

