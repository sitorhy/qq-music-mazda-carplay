import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/store/playing_session.dart';
import 'package:qq_music_client_app/utils/toast.dart';
import 'dart:math' as math;

enum ProcessingStateAdapter {
  /// The player has not loaded
  idle,

  /// The player is loading
  loading,

  /// The player is buffering audio and unable to play.
  buffering,

  /// The player is has enough audio buffered and is able to play.
  ready,

  /// The player has reached the end of the audio.
  completed,
}

class ImmersiveController extends GetxController {
  final player = AudioPlayer(); // Create a player

  Rx<PlayingSession> playingSession = const PlayingSession(0, "", "", []).obs;
  Rx<Song> playingSong = Song(title: "", name: "", songMid: "").obs;
  RxString playingSongLyric = "".obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> current = Duration.zero.obs;
  RxDouble progress = 0.0.obs;
  RxDouble bufferedProgress = 0.0.obs;
  RxBool isPlaying = false.obs;
  Rx<ProcessingStateAdapter> status =
      Rx<ProcessingStateAdapter>(ProcessingStateAdapter.idle);

  // 快进 快退秒数
  RxInt seekingInterval = 5.obs;

  @override
  void onInit() {
    super.onInit();

    status.listen((value) {
      if (value == ProcessingStateAdapter.completed) {
        playNext();
      }
    });

    player.playerStateStream.listen((PlayerState state) {
      switch (state.processingState) {
        case ProcessingState.completed:
          status.value = ProcessingStateAdapter.completed;
          break;
        case ProcessingState.buffering:
          status.value = ProcessingStateAdapter.buffering;
          break;
        case ProcessingState.ready:
          status.value = ProcessingStateAdapter.ready;
          break;
        case ProcessingState.loading:
          status.value = ProcessingStateAdapter.loading;
          break;
        default:
          status.value = ProcessingStateAdapter.idle;
      }
      isPlaying.value = state.playing;
    });
    player.bufferedPositionStream.listen((duration) {
      if (duration.inSeconds == 0) {
        bufferedProgress.value = 0;
        return;
      }
      bufferedProgress.value = duration.inSeconds / duration.inSeconds;
    });
    player.positionStream.listen((position) {
      current.value = position;
      if (duration.value.inSeconds == 0) {
        progress.value = 0;
      } else {
        progress.value = (position.inSeconds / duration.value.inSeconds);
      }
    });
  }

  // 设置歌曲列表，playlist不为空时，绑定到歌单id
  setPlayingList(List<Song> list, Playlist? playlist) async {
    if (playlist != null && playlist.dissId != playingSession.value.dissId) {
      if (list.isEmpty) {
        var response =
            await FetchPlaylistSongsRequest(dissId: playlist.dissId).request();
        playingSession.value =
            PlayingSession(0, "", playlist.uid, response.data ?? []);
      } else {
        playingSession.value = PlayingSession(0, "", playlist.uid, list);
      }
    } else {
      playingSession.value = PlayingSession(0, "", "", list);
    }
    return playingSession.value.songs;
  }

  // 设置
  setAlbum(Album album) async {
    if (album.albumMid != playingSession.value.albumMid) {
      var response = await FetchAlbumSongsRequest(
              albumMid: album.albumMid, albumId: album.albumId)
          .request();
      playingSession.value =
          PlayingSession(0, album.albumMid, album.uid, response.data ?? []);
    }
    return playingSession.value.songs;
  }

  clearPlayingSession() {
    playingSession.value = const PlayingSession(0, "", "", []);
    playingSong.value = Song(title: "", name: "", songMid: "");
    playingSongLyric.value = "";
    duration.value = Duration.zero;
    current.value = Duration.zero;
    isPlaying.value = false;
    progress.value = 0;
    bufferedProgress.value = 0;
    status.value = ProcessingStateAdapter.idle;
  }

  fastBack() {
    if (duration.value.inSeconds <= 0) {
      return;
    }
    int nextSecs = math.min(duration.value.inSeconds,
        current.value.inSeconds - seekingInterval.value);
    player.seek(Duration(seconds: math.max(0, nextSecs)));
  }

  fastForward() {
    if (duration.value.inSeconds <= 0) {
      return;
    }
    int nextSecs = math.max(0, current.value.inSeconds + seekingInterval.value);
    player.seek(Duration(seconds: nextSecs));
  }

  // 进度拖动，模拟器/手机触摸
  seek(double progress) {
    if (![ProcessingStateAdapter.completed, ProcessingStateAdapter.ready]
        .contains(status.value)) {
      return;
    }
    try {
      final duration = player.duration;
      if (duration != null) {
        int secs = (duration.inSeconds * progress).floor();
        player.seek(Duration(seconds: secs));
      }
    } catch (e) {
      toastError(e);
    }
  }

  play(Song? song) async {
    if (song == null) {
      // 继续播放当前
      if (playingSong.value.songMid.isNotEmpty) {
        player.play();
      }
      return;
    }
    try {
      if ([ProcessingStateAdapter.loading].contains(status.value)) {
        return;
      }
      if (song == playingSong.value) {
        return;
      }
      playingSong.value = song;
      playingSongLyric.value = "";
      var response = await FetchSongSourceRequest(
              songMid: song.songMid, songId: song.songId)
          .request();
      String url = response.data ?? "";
      if (url.isNotEmpty) {
        Duration? songDuration = await player.setUrl(url);
        if (songDuration != null) {
          duration.value = songDuration;
        } else {
          duration.value = Duration.zero;
        }
        player.play();
      } else {
        toastError(response.message);
      }
    } catch (e) {
      toastError(e);
    }

    try {
      var response =
          await FetchSongLyricRequest(songMid: song.songMid).request();
      String lyricText = response.data ?? "";
      playingSongLyric.value = lyricText;
    } catch (e) {
      toastError(e);
    }
  }

  playNext() {
    int index = playingSession.value.songs
        .indexWhere((s) => s.uid == playingSong.value.uid);
    if (index >= 0 && index + 1 < playingSession.value.songs.length) {
      play(playingSession.value.songs[index + 1]);
    }
  }

  playPrev() {
    int index = playingSession.value.songs
        .indexWhere((s) => s.uid == playingSong.value.uid);
    if (index >= 0 && index - 1 < playingSession.value.songs.length) {
      play(playingSession.value.songs[math.max(0, index - 1)]);
    }
  }

  pause() async {
    try {
      await player.pause();
    } catch (e) {
      toastError(e);
    }
  }
}
