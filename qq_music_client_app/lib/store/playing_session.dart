import 'package:qq_music_client_app/model/song.dart';

/// 正在播放歌单的绑定详情
class PlayingSession {
  final int dissId; // 是否绑定到特定歌单
  final String albumMid; // 是否绑定到专辑
  final String uid; // 专辑或者歌单唯一id
  final List<Song> songs; // 正在播放的歌曲列表

  const PlayingSession(this.dissId, this.albumMid, this.uid, this.songs);
}