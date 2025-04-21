// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'singer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Singer _$SingerFromJson(Map<String, dynamic> json) => Singer(
      singerId: (json['singerId'] as num).toInt(),
      singerMid: json['singerMid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$SingerToJson(Singer instance) => <String, dynamic>{
      'singerId': instance.singerId,
      'singerMid': instance.singerMid,
      'name': instance.name,
      'description': instance.description,
      'avatarUrl': instance.avatarUrl,
    };
