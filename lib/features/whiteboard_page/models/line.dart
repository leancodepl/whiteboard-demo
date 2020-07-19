import 'package:json_annotation/json_annotation.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/point.dart';

part 'line.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Line {
  const Line(this.points);

  factory Line.fromJson(Map json) => _$LineFromJson(json);

  final List<Point> points;

  Map<String, dynamic> toJson() => _$LineToJson(this);
}
