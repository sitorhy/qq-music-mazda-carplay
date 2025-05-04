import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/follow_controller.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/views/home/category_list.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class MyFavouriteSingers extends StatelessWidget {
  MyFavouriteSingers({super.key});

  final FollowController followController = Get.find(tag: "followController");

  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  @override
  Widget build(BuildContext context) {
    var albumList = Obx(() {
      var currentAlbums = followController.currentAlbums;
      String currentAlbumId = followController.currentAlbumId.value;
      return PositionedSingleScrollView(
        children: currentAlbums.map((album) {
          return PositionedSingleScrollItem(
            child: GestureDetector(
              onTap: () {
                followController.setCurrentAlbum(album);
              },
              child: AlbumSelectOption(
                status: currentAlbumId == album.uid
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
    });

    var songList = Obx(() {
      var songs = followController.currentSongs;
      var currentSingerIndex = followController.currentSingerIndex.value;
      var singer = followController.singers[currentSingerIndex];
      var selectedAlbumIndex =
          followController.singerAlbumIndexMap[singer.singerMid];
      var currentAlbums = followController.currentAlbums;
      var album = currentAlbums[selectedAlbumIndex ?? 0];

      var playingSongMid = immersiveController.playingSong.value.uid;

      return PositionedListView.separated(
        itemCount: songs.length,
        separatorExtent: 4.0,
        itemBuilder: (buildContext, index) {
          var song = songs[index];
          return PositionedListItem(
            index: index,
            child: GestureDetector(
              onTap: () {
                immersiveController.setAlbum(album);
                immersiveController.play(song);
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
          Obx(
            () {
              return CategoryList(
                onActiveIndexChange: (nextIndex) => followController
                    .setCurrentSinger(followController.singers[nextIndex]),
                activeIndex: followController.currentSingerIndex.value,
                categories: followController.singers
                    .map(
                      (singer) => Category(
                        title: singer.name,
                        imageUrl: singer.avatarUrl ?? "",
                      ),
                    )
                    .toList(),
              );
            },
          ),
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
