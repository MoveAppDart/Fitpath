import 'package:json_annotation/json_annotation.dart';

part 'weight_evolution.g.dart';

/// Represents a single data point in the weight evolution chart
@JsonSerializable()
class WeightDataPoint {
  /// The date of the measurement in ISO 8601 format (YYYY-MM-DD)
  final DateTime date;
  
  /// The weight value in kilograms
  final double weight;
  
  /// Optional note about the measurement
  final String? note;
  
  /// Whether this is a goal weight (true) or an actual measurement (false)
  final bool isGoal;

  WeightDataPoint({
    required this.date,
    required this.weight,
    this.note,
    this.isGoal = false,
  });

  /// Creates a [WeightDataPoint] from JSON
  factory WeightDataPoint.fromJson(Map<String, dynamic> json) => 
      _$WeightDataPointFromJson(json);
  
  /// Converts this [WeightDataPoint] to JSON
  Map<String, dynamic> toJson() => _$WeightDataPointToJson(this);
  
  /// Creates a copy of this [WeightDataPoint] with the given fields replaced
  WeightDataPoint copyWith({
    DateTime? date,
    double? weight,
    String? note,
    bool? isGoal,
  }) {
    return WeightDataPoint(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      note: note ?? this.note,
      isGoal: isGoal ?? this.isGoal,
    );
  }
  
  @override
  String toString() => 'WeightDataPoint(date: $date, weight: $weight, isGoal: $isGoal)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WeightDataPoint &&
      other.date == date &&
      other.weight == weight &&
      other.note == note &&
      other.isGoal == isGoal;
  }
  
  @override
  int get hashCode {
    return date.hashCode ^
           weight.hashCode ^
           note.hashCode ^
           isGoal.hashCode;
  }
}
