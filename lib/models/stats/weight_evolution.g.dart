// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_evolution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightDataPoint _$WeightDataPointFromJson(Map<String, dynamic> json) =>
    WeightDataPoint(
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
      note: json['note'] as String?,
      isGoal: json['isGoal'] as bool? ?? false,
    );

Map<String, dynamic> _$WeightDataPointToJson(WeightDataPoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'weight': instance.weight,
      'note': instance.note,
      'isGoal': instance.isGoal,
    };
