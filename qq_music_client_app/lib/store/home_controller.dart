import 'package:get/get.dart';
import 'package:qq_music_client_app/api/albums_api.dart';
import 'package:qq_music_client_app/api/categories_api.dart';
import 'package:qq_music_client_app/api/song_api.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/model/tag-group.dart';
import 'package:qq_music_client_app/model/tag-playlist.dart';
import 'package:qq_music_client_app/model/tag.dart';

class HomeController extends GetxController {
  Rx<int> tagGroupIndex = RxInt(0);
  RxList<TagGroup> tagGroups = RxList([]);

  // 歌单推荐
  RxList<TagPlaylists> recommendTagPlaylists = RxList([]);
  Rx<int> recommendPlaylistIndex = RxInt(0);
  Rx<String> recommendPlaylistId = Rx<String>("");
  RxList<Playlist> recommendPlaylistsReduce = RxList([]);

  // 新歌首发
  Rx<int> newSongTagIndex = RxInt(0);
  Rx<String> newSongTagId = Rx("");
  RxList<Tag> newSongAlbumTags = RxList([]);

  // 新碟首发
  Rx<int> newAlbumTagIndex = RxInt(0);
  Rx<String> newAlbumTagId = Rx("");
  RxList<Tag> newAlbumTags = RxList([]);

  // 排行榜
  Rx<int> topAlbumTagIndex = RxInt(0);
  Rx<String> topAlbumTagId = Rx("");
  RxList<Tag> topAlbumTags = RxList([]);

  // 公共区域
  // 渲染为单曲
  RxList<Song> recommendSongs = RxList([]);
  // 渲染为专辑
  RxList<Album> newSongAlbums = RxList([]);
  RxList<Album> newAlbums = RxList([]);
  RxList<Album> topAlbums = RxList([]);


  @override
  void onInit() async {
    super.onInit();
    await loadTagGroups();
    await loadTags();
    tagGroupIndex.listen((nextGroupIndex) async {
      await loadTags();
    });
  }

  // 推荐
  handleRecommendPlaylistIndexChange() async {
    var playlist = recommendPlaylistsReduce[recommendPlaylistIndex.value];
    var res = await FetchPlaylistSongsRequest(dissId: playlist.dissId).request();
    recommendSongs.value = res.data ?? [];
  }

  setRecommendPlaylistIndex(int index) {
    String id = recommendPlaylistId.value;
    var playlist = recommendPlaylistsReduce.elementAtOrNull(index);
    if (playlist != null && playlist.uid != id) {
      recommendPlaylistIndex.value = index % recommendPlaylistsReduce.length;
      recommendPlaylistId.value = playlist.uid;
      handleRecommendPlaylistIndexChange();
    }
  }

  setFocusedRecommendPlaylist(Playlist playlist) {
    setRecommendPlaylistIndex(recommendPlaylistsReduce.indexOf(playlist));
  }

  // 新歌
  handleNewSongTagIndexChange() async {
    var tag = newSongAlbumTags[newSongTagIndex.value];
    var res = await FetchAlbumsBySongTagRequest(tagId: tag.tagId).request();
    newSongAlbums.value = res.data ?? [];
  }

  setNewSongTagIndex(int index) {
    String id = newSongTagId.value;
    var tag = newSongAlbumTags.elementAtOrNull(index);
    if (tag != null && tag.uid != id) {
      newSongTagIndex.value = index % newSongAlbumTags.length;
      newSongTagId.value = tag.uid;
      handleNewSongTagIndexChange();
    }
  }

  setFocusedNewSongTag(Tag tag) {
    setNewSongTagIndex(newSongAlbumTags.indexOf(tag));
  }

  // 新碟
  handleNewAlbumTagIndexChange() async {
    var tag = newAlbumTags[newSongTagIndex.value];
    var res = await FetchAlbumsByAlbumTagRequest(tagId: tag.tagId).request();
    newAlbums.value = res.data ?? [];
  }

  setNewAlbumTagIndex(int index) {
    String id = newAlbumTagId.value;
    var tag = newAlbumTags.elementAtOrNull(index);
    if (tag != null && tag.uid != id) {
      newAlbumTagIndex.value = index % newAlbumTags.length;
      newAlbumTagId.value = tag.uid;
      handleNewAlbumTagIndexChange();
    }
  }

  setFocusedNewAlbumTag(Tag tag) {
    setNewAlbumTagIndex(newAlbumTags.indexOf(tag));
  }

  // 排行榜
  handleTopAlbumTagIndexChange() async {
    var tag = topAlbumTags[newSongTagIndex.value];
    var res = await FetchAlbumsByTopTagRequest(tagId: tag.tagId).request();
    topAlbums.value = res.data ?? [];
  }

  setTopAlbumTagIndex(int index) {
    String id = topAlbumTagId.value;
    var tag = topAlbumTags.elementAtOrNull(index);
    if (tag != null && tag.uid != id) {
      topAlbumTagIndex.value = index % topAlbumTags.length;
      topAlbumTagId.value = tag.uid;
      handleTopAlbumTagIndexChange();
    }
  }

  setFocusedTopAlbumTag(Tag tag) {
    setTopAlbumTagIndex(topAlbumTags.indexOf(tag));
  }

  loadTagGroups() async {
    List<TagGroup> customTagGroups = [];
    customTagGroups.add(
      TagGroup(tagGroupId: 0, tagGroupName: "歌单推荐"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 1, tagGroupName: "新歌首发"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 2, tagGroupName: "新碟首发"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 3, tagGroupName: "排行榜"),
    );
    tagGroups.value = customTagGroups;
  }

  shouldLoadRecommendTags() async {
    return recommendPlaylistsReduce.isEmpty;
  }

  shouldLoadNewSongTags() async {
    return newSongAlbumTags.isEmpty;
  }

  shouldLoadNewAlbumsTags() async {
    return newAlbumTags.isEmpty;
  }

  shouldLoadTopAlbumsTags() async {
    return topAlbumTags.isEmpty;
  }

  loadTags() async {
    if (tagGroupIndex >= 0 && tagGroupIndex < tagGroups.length) {
      var tagGroup = tagGroups.elementAt(tagGroupIndex.value);
      switch (tagGroup.tagGroupId) {
        // 歌单推荐
        case 0:
          {
            if (!(await shouldLoadRecommendTags())) {
              return;
            }
            var tagsResp = await FetchRecommendedTagsRequest().request();
            List<TagPlaylists> tagPlaylists = [];
            List<Playlist> playlistsReduce = [];
            if (tagsResp.data != null) {
              for (var tag in tagsResp.data!) {
                List<Playlist> playlists = [];
                var playlistsResp =
                    await FetchTagPlaylistsRequest(categoryId: tag.tagId)
                        .request();
                if (playlistsResp.data != null) {
                  playlists.addAll(playlistsResp.data!);
                }
                tagPlaylists.add(TagPlaylists(playlists: playlists, tag: tag));
                playlistsReduce.addAll(playlists);
              }
              recommendTagPlaylists.value = tagPlaylists;
              recommendPlaylistsReduce.value = playlistsReduce;
              setRecommendPlaylistIndex(0);
            }
          }
          break;
        // 新歌首发
        case 1:
          {
            if (!(await shouldLoadNewSongTags())) {
              return;
            }
            var tagsResp = await FetchNewestSongAlbumTagsRequest().request();
            if (tagsResp.data != null) {
              newSongAlbumTags.value = tagsResp.data ?? [];
              setNewSongTagIndex(0);
            }
          }
          break;
        // 新碟首发
        case 2:
          {
            if (!(await shouldLoadNewAlbumsTags())) {
              return;
            }
            var tagsResp = await FetchNewestAlbumTagsRequest().request();
            if (tagsResp.data != null) {
              newAlbumTags.value = tagsResp.data ?? [];
              setNewAlbumTagIndex(0);
            }
          }
          break;
        // 排行榜
        case 3:
          {
            if (!(await shouldLoadTopAlbumsTags())) {
              return;
            }
            var tagsResp = await FetchTopAlbumTagsRequest().request();
            if (tagsResp.data != null) {
              topAlbumTags.value = tagsResp.data ?? [];
              setTopAlbumTagIndex(0);
            }
          }
          break;
      }
    }
  }
}
