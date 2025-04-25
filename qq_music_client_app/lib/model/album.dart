import 'package:json_annotation/json_annotation.dart';
import 'package:qq_music_client_app/model/singer.dart';
import 'package:uuid/uuid.dart';

part 'album.g.dart';

const uuid = Uuid();

@JsonSerializable()
class Album {
  final int albumId;
  final String albumMid;
  final String name;
  final String? cover;
  final int? songCount;
  final List<Singer>? singers;
  final String? description;

  final String uid = uuid.v4();

  Album({
    required this.albumId,
    required this.albumMid,
    required this.name,
    this.cover,
    this.songCount,
    this.singers,
    this.description,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
