import 'package:json_annotation/json_annotation.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/singer.dart';
import 'package:uuid/uuid.dart';

part 'song.g.dart';

const uuid = Uuid();

@JsonSerializable()
class Song {
  final int songId;
  final String songMid;
  final String name;
  final String title;
  final String subtitle;
  final List<Singer> singer;
  final Album? album;
  final int? duration;

  final String uid = uuid.v4();

  Song({
    this.songId = 0,
    this.subtitle = "",
    required this.title,
    required this.name,
    required this.songMid,
    this.singer = const [],
    this.album,
    this.duration,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}
