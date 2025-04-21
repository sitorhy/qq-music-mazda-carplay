import 'package:get/get.dart';
import 'package:qq_music_client_app/api/albums_api.dart';
import 'package:qq_music_client_app/api/categories_api.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/tag-group.dart';
import 'package:qq_music_client_app/model/tag-playlist.dart';
import 'package:qq_music_client_app/model/tag.dart';

class HomeController extends GetxController {
  Rx<int> tagGroupIndex = RxInt(0);
  RxList<TagGroup> tagGroups = RxList([]);

  // 歌单推荐
  RxList<TagPlaylists> recommendTagPlaylists = RxList([]);

  // 新歌首发
  RxList<Tag> newSongAlbumTags = RxList([]);

  // 新碟首发
  RxList<Tag> newAlbumTags = RxList([]);

  @override
  void onInit() async {
    super.onInit();
    await loadTagGroups();
    await loadrecommendTagPlaylists();
    tagGroupIndex.listen((nextGroupIndex) {
      loadrecommendTagPlaylists();
    });
  }

  loadTagGroups() async {
    List<TagGroup> customTagGroups = [];
    customTagGroups.add(
      TagGroup(tagGroupId: 100, tagGroupName: "歌单推荐"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 101, tagGroupName: "新歌首发"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 102, tagGroupName: "新碟首发"),
    );
    customTagGroups.add(
      TagGroup(tagGroupId: 103, tagGroupName: "排行榜"),
    );
    tagGroups.value = customTagGroups;
  }

  loadrecommendTagPlaylists() async {
    if (tagGroupIndex >= 0 && tagGroupIndex < tagGroups.length) {
      var tagGroup = tagGroups.elementAt(tagGroupIndex.value);
      switch (tagGroup.tagGroupId) {
        // 歌单推荐
        case 100:
          {
            var tagsResp = await FetchRecommendedTagsRequest().request();
            List<TagPlaylists> tagPlaylists = [];
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
              }
              recommendTagPlaylists.value = tagPlaylists;
            }
          }
          break;
        // 新歌首发
        case 101:
          {
            var tagsResp = await FetchNewestSongAlbumTagsRequest().request();
            if (tagsResp.data != null) {
              newSongAlbumTags.value = tagsResp.data ?? [];
            }
          }
          break;
        // 新歌首发
        case 102:
          {
            var tagsResp = await FetchNewestAlbumTagsRequest().request();
            if (tagsResp.data != null) {
              newAlbumTags.value = tagsResp.data ?? [];
            }
          }
          break;
      }
    }
  }
}
