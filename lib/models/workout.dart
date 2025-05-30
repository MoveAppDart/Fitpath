class Workout {
  final String id;
  final String name;
  final String description;
  final String type;
  final int duration;
  final DateTime scheduledDate;
  final bool completed;
  final List<dynamic>? exercises;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.duration,
    required this.scheduledDate,
    this.completed = false,
    this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      type: json['type'] ?? 'General',
      duration: json['duration'] ?? 0,
      scheduledDate: json['scheduled_date'] != null 
          ? DateTime.parse(json['scheduled_date']) 
          : DateTime.now(),
      completed: json['completed'] ?? false,
      exercises: json['exercises'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'duration': duration,
      'scheduled_date': scheduledDate.toIso8601String(),
      'completed': completed,
      'exercises': exercises,
    };
  }

  Workout copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? duration,
    DateTime? scheduledDate,
    bool? completed,
    List<dynamic>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completed: completed ?? this.completed,
      exercises: exercises ?? this.exercises,
    );
  }
}
