import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/my_playlists_controller.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class MyPlaylists extends StatelessWidget {
  MyPlaylists({super.key});

  final MyPlaylistsController myPlaylistsController = Get.find(tag: "myPlaylistsController");

  @override
  Widget build(BuildContext context) {
    var playlists = Obx(() {
      var myPlaylists = myPlaylistsController.myPlaylists;
      String currentPlaylistId = myPlaylistsController.currentPlaylistId.value;
      return PositionedListView.separated(
        itemCount: myPlaylists.length,
        separatorExtent: 5,
        itemBuilder: (buildContext, index) {
          var playlist = myPlaylists[index];
          return PositionedListItem(
            index: index,
            child: GestureDetector(
              child: AlbumSelectOption(
                fontSize: 15,
                subtitleFontSize: 12,
                title: playlist.name,
                description: playlist.nickname ?? "",
                status: currentPlaylistId ==
                    playlist.uid
                    ? AlbumSelectOptionStatus.active
                    : AlbumSelectOptionStatus.normal,
              ),
              onTap: () {
                myPlaylistsController.setCurrentPlaylistIndex(index);
              },
            ),
          );
        },
      );
    });

    var songList = Obx(() {
      var currentPlaylistSongs = myPlaylistsController.currentPlaylistSongs;
      return PositionedListView.separated(
        itemCount: currentPlaylistSongs.length,
        separatorExtent: 4.0,
        itemBuilder: (buildContext, index) {
          var song = currentPlaylistSongs[index];
          return PositionedListItem(
            index: index,
            child: SongSelectOption(
              coverUrl: song.album?.cover ?? "",
              fontSize: 15,
              subtitleFontSize: 12,
              thumbSize: 54,
              title: song.name,
              singer: song.singer.map((i) => i.name).join("/"),
              album: song.album?.name ?? "",
              duration: song.duration == null ? null : Duration(seconds: song.duration!),
            ),
          );
        },
      );
    });

    return HomeContentContainer(
      child: Row(
        children: [
          Expanded(
            flex: 23,
            child: playlists,
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
    );
  }
}
