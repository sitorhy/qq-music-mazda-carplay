import 'package:get/get.dart';
import 'package:qq_music_client_app/api/albums_api.dart';
import 'package:qq_music_client_app/api/follow_api.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/singer.dart';
import 'package:qq_music_client_app/model/song.dart';

class FollowController extends GetxController {
  Rx<String> currentSingerId = "".obs;
  RxInt currentSingerIndex = 0.obs;
  RxList<Singer> singers = RxList([]);

  Map<String, List<Song>> singerSongsMap = <String, List<Song>>{};
  Map<String, int> singerAlbumIndexMap = <String, int>{};
  Map<String, List<Album>> singerAlbumsMap = <String, List<Album>>{};

  RxList<Album> currentAlbums = RxList([]);
  RxString currentAlbumId = "".obs;
  RxList<Song> currentSongs = RxList([]);

  @override
  void onInit() async {
    super.onInit();
    await loadSingers();
    currentSingerId.listen(onSingerIdChange);
    if (singers.isNotEmpty) {
      setCurrentSinger(singers[0]);
    }
  }

  onSingerIdChange(singerMid) {
    loadSingerAlbums();
  }

  setCurrentSinger(Singer singer) {
    currentSingerId.value = singer.singerMid;
    currentSingerIndex.value = singers.indexOf(singer);
  }

  loadSingers() async {
    var response = await FetchFollowSingersRequest().request();
    singers.value = response.data ?? [];
  }

  loadSingerAlbums() async {
    if (singerAlbumsMap.containsKey(currentSingerId.value)) {
      currentAlbums.value = singerAlbumsMap[currentSingerId.value]!;
      int albumIndex = singerAlbumIndexMap[currentSingerId.value]!;
      var album = currentAlbums[albumIndex];
      currentAlbumId.value = album.uid;
      loadAlbumSongs();
      return;
    }
    var response = await FetchSingerAlbumsRequest(singerMid: currentSingerId.value).request();
    singerAlbumsMap[currentSingerId.value] = response.data ?? [];
    singerAlbumIndexMap[currentSingerId.value] = 0;
    currentAlbums.value = singerAlbumsMap[currentSingerId.value]!;
    currentAlbumId.value = currentAlbums[0].uid;
    loadAlbumSongs();
  }

  loadAlbumSongs() async {
    var album = currentAlbums.firstWhereOrNull((i) => i.uid == currentAlbumId.value);
    if (album != null) {
      if (singerSongsMap.containsKey(album.albumMid)) {
        currentSongs.value = singerSongsMap[album.albumMid] ?? [];
        return;
      } else {
        var response = await FetchAlbumSongsRequest(albumMid: album.albumMid).request();
        singerSongsMap[album.albumMid] = response.data ?? [];
        currentSongs.value = singerSongsMap[album.albumMid] ?? [];
      }
    }
  }

  setCurrentAlbum(Album album) {
    int index = currentAlbums.indexOf(album);
    if (index >= 0) {
      Album album = currentAlbums[index];
      currentAlbumId.value = album.uid;
      singerAlbumIndexMap[currentSingerId.value] = index;
      loadAlbumSongs();
    }
  }
}