import 'package:get/get.dart';
import 'package:qq_music_client_app/api/albums_api.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/model/tag-group.dart';

class FavouriteController extends GetxController {
  Rx<int> tagGroupIndex = RxInt(0);
  RxList<TagGroup> tagGroups = RxList([]);

  Rx<int> favPlaylistIndex = RxInt(0);
  Rx<String> favPlaylistId = Rx("");
  RxList<Playlist> favPlaylists = RxList([]);

  Rx<int> favAlbumIndex = RxInt(0);
  Rx<String> favAlbumId = Rx("");
  RxList<Album> favAlbums = RxList([]);

  RxList<Song> favPlaylistSongs = RxList([]);
  RxList<Song> favAlbumSongs = RxList([]);

  @override
  void onInit() async {
    super.onInit();
    await loadTagGroups();
    await loadFav();
    tagGroupIndex.listen((nextGroupIndex) async {
      await loadFav();
    });
  }

  loadTagGroups() async {
    List<TagGroup> customTagGroups = [];
    customTagGroups.add(
      TagGroup(tagGroupId: 0, tagGroupName: "收藏的歌单"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 1, tagGroupName: "收藏的专辑"),
    );
    tagGroups.value = customTagGroups;
  }

  // 收藏的歌单
  handleFavPlaylistIndexChange() async {
    var playlist = favPlaylists[favPlaylistIndex.value];
    var res =
        await FetchPlaylistSongsRequest(dissId: playlist.dissId).request();
    favPlaylistSongs.value = res.data ?? [];
  }

  setFavPlaylistIndex(int index) {
    String id = favPlaylistId.value;
    var playlist = favPlaylists.elementAtOrNull(index);
    if (playlist != null && playlist.uid != id) {
      favPlaylistIndex.value = index % favPlaylists.length;
      favPlaylistId.value = playlist.uid;
      handleFavPlaylistIndexChange();
    }
  }

  setFavPlaylist(Playlist playlist) {
    setFavPlaylistIndex(favPlaylists.indexOf(playlist));
  }

  // 收藏的专辑
  handleFavAlbumIndexChange() async {
    var album = favAlbums[favAlbumIndex.value];
    var res = await FetchAlbumSongsRequest(albumMid: album.albumMid).request();
    favAlbumSongs.value = res.data ?? [];
  }

  setFavAlbumIndex(int index) {
    String id = favAlbumId.value;
    var album = favAlbums.elementAtOrNull(index);
    if (album != null && album.uid != id) {
      favAlbumIndex.value = index % favAlbums.length;
      favAlbumId.value = album.uid;
      handleFavAlbumIndexChange();
    }
  }

  setFavAlbum(Album album) {
    setFavAlbumIndex(favAlbums.indexOf(album));
  }

  shouldLoadFavPlaylists() async {
    return favPlaylists.isEmpty;
  }

  shouldLoadAlbums() async {
    return favAlbums.isEmpty;
  }

  loadFav() async {
    if (tagGroupIndex >= 0 && tagGroupIndex < tagGroups.length) {
      var tagGroup = tagGroups.elementAt(tagGroupIndex.value);
      switch (tagGroup.tagGroupId) {
        case 0:
          {
            if (!(await shouldLoadFavPlaylists())) {
              return;
            }
            var tagsResp = await FetchMyFavPlaylistsRequest().request();
            favPlaylists.value = tagsResp.data ?? [];
            setFavPlaylistIndex(0);
          }
          break;
        case 1:
          {
            if (!(await shouldLoadAlbums())) {
              return;
            }
            var tagsResp = await FetchMyFavAlbumsRequest().request();
            favAlbums.value = tagsResp.data ?? [];
            setFavAlbumIndex(0);
          }
          break;
      }
    }
  }
}
