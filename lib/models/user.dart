class User {
  final String id;  // Cambiado de int a String
  final String email;
  final String name;
  final String? lastName; // Usamos String? para campos que podrían no venir o ser opcionales
  final int? age;
  final String? gender;
  final DateTime? registrationDate;
  final DateTime? lastLogin;
  final String? profilePicture;
  final bool? isActive;
  final String? role;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.lastName,
    this.age,
    this.gender,
    this.registrationDate,
    this.lastLogin,
    this.profilePicture,
    this.isActive = true, // Defaulting isActive to true as per user's example
    this.role = 'user',   // Defaulting role to 'user' as per user's example
  });

  // Helper para parsear IDs que pueden venir en diferentes formatos
  static String _parseIdToString(dynamic id) {
    if (id == null) return '';
    if (id is String) return id;
    return id.toString();
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    // Intentar extraer el ID del usuario de diferentes campos posibles
    String userId = '';
    if (json.containsKey('userId') && json['userId'] != null) {
      userId = _parseIdToString(json['userId']);
    } else if (json.containsKey('id') && json['id'] != null) {
      userId = _parseIdToString(json['id']);
    } else if (json.containsKey('_id') && json['_id'] != null) {
      userId = _parseIdToString(json['_id']);
    }
    
    // Extraer email y nombre con manejo seguro de tipos
    String email = '';
    if (json.containsKey('email') && json['email'] != null) {
      email = json['email'].toString();
    }
    
    String name = 'Usuario';
    if (json.containsKey('name') && json['name'] != null) {
      name = json['name'].toString();
    } else if (json.containsKey('userName') && json['userName'] != null) {
      name = json['userName'].toString();
    }
    
    // Extraer campos opcionales con manejo seguro de tipos
    String? lastName;
    if (json.containsKey('lastName') && json['lastName'] != null) {
      lastName = json['lastName'].toString();
    }
    
    int? age;
    if (json.containsKey('age') && json['age'] != null) {
      if (json['age'] is int) {
        age = json['age'];
      } else if (json['age'] is String) {
        age = int.tryParse(json['age']);
      } else if (json['age'] is double) {
        age = json['age'].toInt();
      }
    }
    
    String? gender;
    if (json.containsKey('gender') && json['gender'] != null) {
      gender = json['gender'].toString();
    }
    
    DateTime? registrationDate;
    if (json.containsKey('registrationDate') && json['registrationDate'] != null) {
      try {
        registrationDate = DateTime.parse(json['registrationDate'].toString());
      } catch (e) {
        print('Error parsing registrationDate: $e');
      }
    }
    
    DateTime? lastLogin;
    if (json.containsKey('lastLogin') && json['lastLogin'] != null) {
      try {
        lastLogin = DateTime.parse(json['lastLogin'].toString());
      } catch (e) {
        print('Error parsing lastLogin: $e');
      }
    }
    
    String? profilePicture;
    if (json.containsKey('profilePicture') && json['profilePicture'] != null) {
      profilePicture = json['profilePicture'].toString();
    }
    
    bool? isActive;
    if (json.containsKey('isActive') && json['isActive'] != null) {
      if (json['isActive'] is bool) {
        isActive = json['isActive'];
      } else if (json['isActive'] is String) {
        isActive = json['isActive'].toString().toLowerCase() == 'true';
      } else if (json['isActive'] is num) {
        isActive = json['isActive'] != 0;
      }
    }
    
    String? role;
    if (json.containsKey('role') && json['role'] != null) {
      role = json['role'].toString();
    }
    
    return User(
      id: userId,
      email: email,
      name: name,
      lastName: lastName,
      age: age,
      gender: gender,
      registrationDate: registrationDate,
      lastLogin: lastLogin,
      profilePicture: profilePicture,
      isActive: isActive,
      role: role,
    );
  }
  
  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'registrationDate': registrationDate?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'profilePicture': profilePicture,
      'isActive': isActive,
      'role': role,
    };
  }
  
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
