// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_frequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutFrequency _$WorkoutFrequencyFromJson(Map<String, dynamic> json) =>
    WorkoutFrequency(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      periodType: json['periodType'] as String,
      workoutCount: (json['workoutCount'] as num).toInt(),
      totalDurationMinutes: (json['totalDurationMinutes'] as num).toInt(),
      averageDurationMinutes:
          (json['averageDurationMinutes'] as num).toDouble(),
      mostFrequentDay: (json['mostFrequentDay'] as num?)?.toInt(),
      workoutTypeCount: (json['workoutTypeCount'] as num).toInt(),
      mostFrequentWorkoutType: json['mostFrequentWorkoutType'] as String?,
    );

Map<String, dynamic> _$WorkoutFrequencyToJson(WorkoutFrequency instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'periodType': instance.periodType,
      'workoutCount': instance.workoutCount,
      'totalDurationMinutes': instance.totalDurationMinutes,
      'averageDurationMinutes': instance.averageDurationMinutes,
      'mostFrequentDay': instance.mostFrequentDay,
      'workoutTypeCount': instance.workoutTypeCount,
      'mostFrequentWorkoutType': instance.mostFrequentWorkoutType,
    };
