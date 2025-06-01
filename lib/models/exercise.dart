class Exercise {
  final String? id;
  final String name;
  final String? description;
  final String type;
  final String targetMuscle;
  final String? difficultyLevel;
  final List<String>? equipment;
  final List<String>? instructions;
  final String? imageUrl;
  final String? videoUrl;
  final bool isPublic;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Exercise({
    this.id,
    required this.name,
    this.description,
    required this.type,
    required this.targetMuscle,
    this.difficultyLevel,
    this.equipment,
    this.instructions,
    this.imageUrl,
    this.videoUrl,
    this.isPublic = false,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      targetMuscle: json['targetMuscle'] as String,
      difficultyLevel: json['difficultyLevel'] as String?,
      equipment: (json['equipment'] as List<dynamic>?)?.cast<String>(),
      instructions: (json['instructions'] as List<dynamic>?)?.cast<String>(),
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'type': type,
      'targetMuscle': targetMuscle,
      if (difficultyLevel != null) 'difficultyLevel': difficultyLevel,
      if (equipment != null) 'equipment': equipment,
      if (instructions != null) 'instructions': instructions,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (videoUrl != null) 'videoUrl': videoUrl,
      'isPublic': isPublic,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? targetMuscle,
    String? difficultyLevel,
    List<String>? equipment,
    List<String>? instructions,
    String? imageUrl,
    String? videoUrl,
    bool? isPublic,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isPublic: isPublic ?? this.isPublic,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
