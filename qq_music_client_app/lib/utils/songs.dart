import 'package:qq_music_client_app/model/song.dart';

extension SongListExtension on List<Song> {
  hasSong(Song song) {
    return indexWhere((s) => s.songMid == song.songMid) >= 0;
  }
}