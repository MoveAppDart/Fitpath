import 'package:json_annotation/json_annotation.dart';

part 'personal_best.g.dart';

/// Represents a personal best record for an exercise
@JsonSerializable()
class PersonalBest {
  /// The ID of the exercise
  final String exerciseId;
  
  /// The name of the exercise
  final String exerciseName;
  
  /// The best weight lifted (in kg)
  final double? bestWeight;
  
  /// The best number of reps
  final int? bestReps;
  
  /// The best one-rep max (1RM) calculated
  final double? oneRepMax;
  
  /// The date when this record was achieved
  final DateTime? achievedAt;
  
  /// The ID of the workout where this record was achieved
  final String? workoutId;
  
  /// The name of the workout where this record was achieved
  final String? workoutName;

  PersonalBest({
    required this.exerciseId,
    required this.exerciseName,
    this.bestWeight,
    this.bestReps,
    this.oneRepMax,
    this.achievedAt,
    this.workoutId,
    this.workoutName,
  });

  /// Creates a [PersonalBest] from JSON
  factory PersonalBest.fromJson(Map<String, dynamic> json) => 
      _$PersonalBestFromJson(json);
  
  /// Converts this [PersonalBest] to JSON
  Map<String, dynamic> toJson() => _$PersonalBestToJson(this);
  
  /// Creates a copy of this [PersonalBest] with the given fields replaced
  PersonalBest copyWith({
    String? exerciseId,
    String? exerciseName,
    double? bestWeight,
    int? bestReps,
    double? oneRepMax,
    DateTime? achievedAt,
    String? workoutId,
    String? workoutName,
  }) {
    return PersonalBest(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      bestWeight: bestWeight ?? this.bestWeight,
      bestReps: bestReps ?? this.bestReps,
      oneRepMax: oneRepMax ?? this.oneRepMax,
      achievedAt: achievedAt ?? this.achievedAt,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
    );
  }
  
  @override
  String toString() => 'PersonalBest(exercise: $exerciseName, weight: $bestWeight, reps: $bestReps, 1RM: $oneRepMax)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is PersonalBest &&
      other.exerciseId == exerciseId &&
      other.exerciseName == exerciseName &&
      other.bestWeight == bestWeight &&
      other.bestReps == bestReps &&
      other.oneRepMax == oneRepMax &&
      other.achievedAt == achievedAt &&
      other.workoutId == workoutId &&
      other.workoutName == workoutName;
  }
  
  @override
  int get hashCode {
    return exerciseId.hashCode ^
           exerciseName.hashCode ^
           bestWeight.hashCode ^
           bestReps.hashCode ^
           oneRepMax.hashCode ^
           achievedAt.hashCode ^
           workoutId.hashCode ^
           workoutName.hashCode;
  }
}
