class Profile {
  final String id;
  final String userId;
  final double weight;
  final double height;
  final String fitnessLevel;
  final List<String>? goals;
  final List<String>? preferredWorkouts;
  final String measurementSystem;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    this.weight = 0,
    this.height = 0,
    this.fitnessLevel = '',
    this.goals,
    this.preferredWorkouts,
    this.measurementSystem = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper para parsear IDs que pueden venir en diferentes formatos
  static String _parseIdToString(dynamic id) {
    if (id == null) return '';
    if (id is String) return id;
    return id.toString();
  }

  // Helper para parsear fechas con manejo de errores
  static DateTime _parseDateSafely(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
        // Timestamp en milisegundos
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    
    return DateTime.now();
  }

  // Helper para parsear listas de strings
  static List<String>? _parseStringList(dynamic listValue) {
    if (listValue == null) return null;
    
    try {
      if (listValue is List) {
        return listValue.map((e) => e.toString()).toList();
      }
    } catch (e) {
      print('Error parsing list: $e');
    }
    
    return null;
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    // Extraer IDs con manejo robusto
    String profileId = '';
    if (json.containsKey('id') && json['id'] != null) {
      profileId = _parseIdToString(json['id']);
    } else if (json.containsKey('_id') && json['_id'] != null) {
      profileId = _parseIdToString(json['_id']);
    } else if (json.containsKey('profileId') && json['profileId'] != null) {
      profileId = _parseIdToString(json['profileId']);
    }
    
    String userIdValue = '';
    if (json.containsKey('userId') && json['userId'] != null) {
      userIdValue = _parseIdToString(json['userId']);
    } else if (json.containsKey('user_id') && json['user_id'] != null) {
      userIdValue = _parseIdToString(json['user_id']);
    }
    
    // Extraer datos numéricos con manejo robusto
    double weightValue = 0;
    if (json.containsKey('weight') && json['weight'] != null) {
      if (json['weight'] is num) {
        weightValue = (json['weight'] as num).toDouble();
      } else if (json['weight'] is String) {
        weightValue = double.tryParse(json['weight']) ?? 0;
      }
    }
    
    double heightValue = 0;
    if (json.containsKey('height') && json['height'] != null) {
      if (json['height'] is num) {
        heightValue = (json['height'] as num).toDouble();
      } else if (json['height'] is String) {
        heightValue = double.tryParse(json['height']) ?? 0;
      }
    }
    
    // Extraer strings con manejo robusto
    String fitnessLevelValue = '';
    if (json.containsKey('fitnessLevel') && json['fitnessLevel'] != null) {
      fitnessLevelValue = json['fitnessLevel'].toString();
    }
    
    String measurementSystemValue = '';
    if (json.containsKey('measurementSystem') && json['measurementSystem'] != null) {
      measurementSystemValue = json['measurementSystem'].toString();
    }
    
    // Extraer fechas con manejo robusto
    DateTime createdAtValue = DateTime.now();
    if (json.containsKey('createdAt') && json['createdAt'] != null) {
      createdAtValue = _parseDateSafely(json['createdAt']);
    }
    
    DateTime updatedAtValue = DateTime.now();
    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      updatedAtValue = _parseDateSafely(json['updatedAt']);
    }
    
    return Profile(
      id: profileId,
      userId: userIdValue,
      weight: weightValue,
      height: heightValue,
      fitnessLevel: fitnessLevelValue,
      goals: _parseStringList(json['goals']),
      preferredWorkouts: _parseStringList(json['preferredWorkouts']),
      measurementSystem: measurementSystemValue,
      createdAt: createdAtValue,
      updatedAt: updatedAtValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'fitnessLevel': fitnessLevel,
      'goals': goals,
      'preferredWorkouts': preferredWorkouts,
      'measurementSystem': measurementSystem,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
