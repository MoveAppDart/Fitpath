class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final String? videoUrl;
  final Map<String, dynamic>? instructions;
  final List<String>? targetMuscles;
  final List<String>? equipment;
  final int? difficulty; // 1-5 escala de dificultad

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    this.instructions,
    this.targetMuscles,
    this.equipment,
    this.difficulty,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      instructions: json['instructions'],
      targetMuscles: json['target_muscles'] != null 
          ? List<String>.from(json['target_muscles']) 
          : null,
      equipment: json['equipment'] != null 
          ? List<String>.from(json['equipment']) 
          : null,
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'instructions': instructions,
      'target_muscles': targetMuscles,
      'equipment': equipment,
      'difficulty': difficulty,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    String? videoUrl,
    Map<String, dynamic>? instructions,
    List<String>? targetMuscles,
    List<String>? equipment,
    int? difficulty,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      instructions: instructions ?? this.instructions,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
