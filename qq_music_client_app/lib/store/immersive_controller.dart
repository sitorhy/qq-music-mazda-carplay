import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/utils/toast.dart';

class ImmersiveController extends GetxController {
  final player = AudioPlayer();                   // Create a player

  Rx<Song> playingSong = Song(title: "", name: "", songMid: "").obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> current = Duration.zero.obs;
  RxDouble progress = 0.0.obs;
  RxDouble seekingProgress = 0.0.obs;
  RxDouble loadingProgress = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isSeeking = false.obs;

  RxList<Song> playingList = RxList([]);


  @override
  void onInit() {
    super.onInit();
    player.positionStream.listen((position) {
      current.value = position;
      if (duration.value.inSeconds == 0) {
        progress.value = 0;
      } else {
        progress.value = (position.inSeconds / duration.value.inSeconds);
      }
    });
  }

  seek(double progress) {

  }

  play(Song song) async {
    try {
      var response = await FetchSongSourceRequest(songMid: song.songMid, songId: song.songId).request();
      String url = response.data ?? "";
      if (url.isNotEmpty) {
        Duration? songDuration = await player.setUrl(url);
        if (songDuration != null) {
          duration.value = songDuration;
        } else {
          duration.value = Duration.zero;
        }
        await player.play();
      } else {
        toastError(response.message);
      }
    } catch (e) {
      toastError(e);
    }
    // final duration = await player.setUrl();
  }
}