class User {
  final int id;
  final String name;
  final String email;
  final String? profilePicture;
  final double? height;
  final double? weight;
  final String? gender;
  final DateTime? birthDate;
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.height,
    this.weight,
    this.gender,
    this.birthDate,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      gender: json['gender'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_picture': profilePicture,
      'height': height,
      'weight': weight,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'preferences': preferences,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? profilePicture,
    double? height,
    double? weight,
    String? gender,
    DateTime? birthDate,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      preferences: preferences ?? this.preferences,
    );
  }
}
