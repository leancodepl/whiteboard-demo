// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map json) {
  return Line(
    (json['points'] as List)
        ?.map((e) => e == null
            ? null
            : Point.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'points': instance.points?.map((e) => e?.toJson())?.toList(),
    };
