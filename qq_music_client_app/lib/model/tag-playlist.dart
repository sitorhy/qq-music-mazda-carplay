import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/tag.dart';

class TagPlaylists {
  final Tag? tag;
  final List<Playlist> playlists;

  TagPlaylists({
    this.tag,
    required this.playlists,
  });
}
