// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whiteboard_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhiteboardContent _$WhiteboardContentFromJson(Map json) {
  return WhiteboardContent(
    json['id'] as String,
    (json['lines'] as List)
        ?.map((e) => e == null ? null : Line.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$WhiteboardContentToJson(WhiteboardContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lines': instance.lines?.map((e) => e?.toJson())?.toList(),
    };
