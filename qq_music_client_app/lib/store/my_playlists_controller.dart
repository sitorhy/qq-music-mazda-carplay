import 'package:get/get.dart';
import 'package:qq_music_client_app/api/albums_api.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/song.dart';

class MyPlaylistsController extends GetxController {
  RxList<Playlist> myPlaylists = RxList([]);
  RxInt currentPlaylistIndex = 0.obs;
  RxString currentPlaylistId = "".obs;
  RxList<Song> currentPlaylistSongs = RxList([]);

  @override
  void onInit() async {
    super.onInit();
    await loadMyPlaylists();
    handleCurrentPlaylistIndexChange();
    if (myPlaylists.isNotEmpty) {
      setCurrentPlaylistIndex(0);
    }
    currentPlaylistIndex.listen((int nextPlaylistIndex) {
      handleCurrentPlaylistIndexChange();
    });
  }

  loadMyPlaylists() async {
    var response =  await FetchMyPlaylistsRequest().request();
    myPlaylists.value = response.data ?? [];
  }

  handleCurrentPlaylistIndexChange() async {
    if (currentPlaylistIndex.value < myPlaylists.length) {
      var playlist = myPlaylists[currentPlaylistIndex.value];
      var response = await FetchPlaylistSongsRequest(dissId: playlist.dissId).request();
      currentPlaylistSongs.value = response.data ?? [];
    }
  }
  
  setCurrentPlaylistIndex(int nextIndex) {
    currentPlaylistIndex.value = nextIndex;
    currentPlaylistId.value = myPlaylists[nextIndex].uid;
  }
  
  setCurrentPlaylist(Playlist playlist) {
    int index = myPlaylists.indexOf(playlist);
    if (index >= 0) {
      setCurrentPlaylistIndex(index);
    }
  }
}