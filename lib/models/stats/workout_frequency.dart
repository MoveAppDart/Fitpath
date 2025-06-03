import 'package:json_annotation/json_annotation.dart';

part 'workout_frequency.g.dart';

/// Represents workout frequency statistics for a specific time period
@JsonSerializable()
class WorkoutFrequency {
  /// The start date of the period
  final DateTime startDate;
  
  /// The end date of the period
  final DateTime endDate;
  
  /// The period type (e.g., 'week', 'month', 'year')
  final String periodType;
  
  /// The number of workouts completed in this period
  final int workoutCount;
  
  /// The total duration of all workouts in this period (in minutes)
  final int totalDurationMinutes;
  
  /// The average duration of workouts in this period (in minutes)
  final double averageDurationMinutes;
  
  /// The most frequent workout day of the week (0-6, where 0 is Sunday)
  final int? mostFrequentDay;
  
  /// The number of different workout types in this period
  final int workoutTypeCount;
  
  /// The most frequent workout type in this period
  final String? mostFrequentWorkoutType;

  WorkoutFrequency({
    required this.startDate,
    required this.endDate,
    required this.periodType,
    required this.workoutCount,
    required this.totalDurationMinutes,
    required this.averageDurationMinutes,
    this.mostFrequentDay,
    required this.workoutTypeCount,
    this.mostFrequentWorkoutType,
  });

  /// Creates a [WorkoutFrequency] from JSON
  factory WorkoutFrequency.fromJson(Map<String, dynamic> json) => 
      _$WorkoutFrequencyFromJson(json);
  
  /// Converts this [WorkoutFrequency] to JSON
  Map<String, dynamic> toJson() => _$WorkoutFrequencyToJson(this);
  
  /// Creates a copy of this [WorkoutFrequency] with the given fields replaced
  WorkoutFrequency copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? periodType,
    int? workoutCount,
    int? totalDurationMinutes,
    double? averageDurationMinutes,
    int? mostFrequentDay,
    int? workoutTypeCount,
    String? mostFrequentWorkoutType,
  }) {
    return WorkoutFrequency(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      periodType: periodType ?? this.periodType,
      workoutCount: workoutCount ?? this.workoutCount,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      averageDurationMinutes: averageDurationMinutes ?? this.averageDurationMinutes,
      mostFrequentDay: mostFrequentDay ?? this.mostFrequentDay,
      workoutTypeCount: workoutTypeCount ?? this.workoutTypeCount,
      mostFrequentWorkoutType: mostFrequentWorkoutType ?? this.mostFrequentWorkoutType,
    );
  }
  
  @override
  String toString() => 'WorkoutFrequency($startDate to $endDate: $workoutCount workouts)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WorkoutFrequency &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.periodType == periodType &&
      other.workoutCount == workoutCount &&
      other.totalDurationMinutes == totalDurationMinutes &&
      other.averageDurationMinutes == averageDurationMinutes &&
      other.mostFrequentDay == mostFrequentDay &&
      other.workoutTypeCount == workoutTypeCount &&
      other.mostFrequentWorkoutType == mostFrequentWorkoutType;
  }
  
  @override
  int get hashCode {
    return startDate.hashCode ^
           endDate.hashCode ^
           periodType.hashCode ^
           workoutCount ^
           totalDurationMinutes ^
           averageDurationMinutes.hashCode ^
           mostFrequentDay.hashCode ^
           workoutTypeCount ^
           mostFrequentWorkoutType.hashCode;
  }
}
