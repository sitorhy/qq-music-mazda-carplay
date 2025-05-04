import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/favourite_controller.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/views/home/category_list.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class MyFavouritePlaylists extends StatelessWidget {
  MyFavouritePlaylists({super.key});

  final FavouriteController favouriteController =
      Get.find(tag: "favController");
  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  @override
  Widget build(BuildContext context) {
    var albumList = Obx(() {
      var groupIndex = favouriteController.tagGroupIndex.value;
      if (groupIndex == 0) {
        var favPlaylists = favouriteController.favPlaylists;
        String favPlaylistId = favouriteController.favPlaylistId.value;
        return PositionedSingleScrollView(
          children: favPlaylists.map((playlist) {
            return PositionedSingleScrollItem(
              child: GestureDetector(
                onTap: () {
                  favouriteController.setFavPlaylist(playlist);
                },
                child: AlbumSelectOption(
                  status: favPlaylistId == playlist.uid
                      ? AlbumSelectOptionStatus.active
                      : AlbumSelectOptionStatus.normal,
                  looseDescription: true,
                  fontSize: 15,
                  subtitleFontSize: 12,
                  title: playlist.name,
                  description: playlist.nickname ?? "",
                ),
              ),
            );
          }).toList(),
        );
      } else {
        var favAlbums = favouriteController.favAlbums;
        var favAlbumId = favouriteController.favAlbumId.value;
        return PositionedSingleScrollView(
          children: favAlbums.map((album) {
            return PositionedSingleScrollItem(
              child: GestureDetector(
                onTap: () {
                  favouriteController.setFavAlbum(album);
                },
                child: AlbumSelectOption(
                  status: favAlbumId == album.uid
                      ? AlbumSelectOptionStatus.active
                      : AlbumSelectOptionStatus.normal,
                  looseDescription: true,
                  fontSize: 15,
                  subtitleFontSize: 12,
                  title: album.name,
                  description: (album.singers ?? [])
                      .map((singer) => singer.name)
                      .join("/"),
                ),
              ),
            );
          }).toList(),
        );
      }
    });

    var songList = Obx(() {
      var playingSongMid = immersiveController.playingSong.value.uid;
      var songs = favouriteController.tagGroupIndex.value == 0
          ? favouriteController.favPlaylistSongs
          : favouriteController.favAlbumSongs;
      return PositionedListView.separated(
        itemCount: songs.length,
        separatorExtent: 4.0,
        itemBuilder: (buildContext, index) {
          var song = songs[index];
          return PositionedListItem(
            index: index,
            child: GestureDetector(
              onTap: () {
                if (favouriteController.tagGroupIndex.value == 0) {
                  var favPlaylists = favouriteController.favPlaylists;
                  var playlist = favPlaylists[favouriteController.favPlaylistIndex.value];
                  immersiveController.setPlayingList(songs, playlist);
                  immersiveController.play(song);
                } else {
                  var favAlbums = favouriteController.favAlbums;
                  var album = favAlbums[favouriteController.favAlbumIndex.value];
                  immersiveController.setAlbum(album);
                  immersiveController.play(song);
                }
              },
              child: SongSelectOption(
                highLight: playingSongMid == song.uid,
                coverUrl: song.album?.cover ?? "",
                fontSize: 15,
                subtitleFontSize: 12,
                thumbSize: 54,
                title: song.title,
                singer: song.singer.map((i) => i.name).join("/"),
                album: song.album?.name ?? "",
                duration: song.duration == null
                    ? null
                    : Duration(seconds: song.duration!),
              ),
            ),
          );
        },
      );
    });

    return HomeContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            return CategoryList(
              activeIndex: favouriteController.tagGroupIndex.value,
              categories: favouriteController.tagGroups.map((tagGroup) {
                return Category(title: tagGroup.tagGroupName);
              }).toList(),
              onActiveIndexChange: (nextIndex) {
                favouriteController.tagGroupIndex.value = nextIndex;
              },
            );
          }),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 23,
                  child: albumList,
                ),
                const Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(),
                  ),
                ),
                Expanded(
                  flex: 75,
                  child: songList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
