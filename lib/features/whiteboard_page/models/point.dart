import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

@JsonSerializable(anyMap: true)
class Point {
  const Point(this.x, this.y);

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  final double x;
  final double y;

  Map<String, dynamic> toJson() => _$PointToJson(this);
}
