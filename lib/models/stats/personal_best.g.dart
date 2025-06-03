// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_best.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalBest _$PersonalBestFromJson(Map<String, dynamic> json) => PersonalBest(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      bestWeight: (json['bestWeight'] as num?)?.toDouble(),
      bestReps: (json['bestReps'] as num?)?.toInt(),
      oneRepMax: (json['oneRepMax'] as num?)?.toDouble(),
      achievedAt: json['achievedAt'] == null
          ? null
          : DateTime.parse(json['achievedAt'] as String),
      workoutId: json['workoutId'] as String?,
      workoutName: json['workoutName'] as String?,
    );

Map<String, dynamic> _$PersonalBestToJson(PersonalBest instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'bestWeight': instance.bestWeight,
      'bestReps': instance.bestReps,
      'oneRepMax': instance.oneRepMax,
      'achievedAt': instance.achievedAt?.toIso8601String(),
      'workoutId': instance.workoutId,
      'workoutName': instance.workoutName,
    };
