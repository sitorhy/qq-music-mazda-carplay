// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      name: json['name'] as String,
      cover: json['cover'] as String?,
      songCount: (json['songCount'] as num?)?.toInt(),
      dissId: (json['dissId'] as num).toInt(),
      dirId: (json['dirId'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'name': instance.name,
      'cover': instance.cover,
      'songCount': instance.songCount,
      'dissId': instance.dissId,
      'dirId': instance.dirId,
      'nickname': instance.nickname,
    };
