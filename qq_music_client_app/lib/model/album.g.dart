// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      albumId: (json['albumId'] as num).toInt(),
      albumMid: json['albumMid'] as String,
      name: json['name'] as String,
      cover: json['cover'] as String?,
      songCount: (json['songCount'] as num?)?.toInt(),
      singers: (json['singers'] as List<dynamic>?)
          ?.map((e) => Singer.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'albumId': instance.albumId,
      'albumMid': instance.albumMid,
      'name': instance.name,
      'cover': instance.cover,
      'songCount': instance.songCount,
      'singers': instance.singers,
      'description': instance.description,
    };
