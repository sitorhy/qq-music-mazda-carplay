// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      songId: (json['songId'] as num?)?.toInt() ?? 0,
      subtitle: json['subtitle'] as String? ?? "",
      title: json['title'] as String,
      name: json['name'] as String,
      songMid: json['songMid'] as String,
      singer: (json['singer'] as List<dynamic>?)
              ?.map((e) => Singer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      album: json['album'] == null
          ? null
          : Album.fromJson(json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'songId': instance.songId,
      'songMid': instance.songMid,
      'name': instance.name,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'singer': instance.singer,
      'album': instance.album,
    };
