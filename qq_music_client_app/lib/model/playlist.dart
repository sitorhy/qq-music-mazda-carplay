import 'package:json_annotation/json_annotation.dart';
import 'package:qq_music_client_app/utils/uuid.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist {
  final String name;
  final String? cover;
  final int? songCount;
  final int dissId;
  final int? dirId;
  final String? nickname;
  late final String uid;

  Playlist({
    required this.name,
    this.cover,
    this.songCount,
    required this.dissId,
    this.dirId,
    this.nickname,
  }) {
    uid = generateModelRenderUuid(dissId.toString());
  }

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
