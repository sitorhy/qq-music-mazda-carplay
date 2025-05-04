import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class DrawerPlaylist extends StatelessWidget {
  DrawerPlaylist({super.key});

  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var playingSession = immersiveController.playingSession.value;
      var playingSongMid = immersiveController.playingSong.value.uid;
      var songs = playingSession.songs;

      return PositionedListView.separated(
        itemCount: songs.length,
        separatorExtent: 4.0,
        itemBuilder: (buildContext, index) {
          var song = songs[index];
          return PositionedListItem(
            index: index,
            child: GestureDetector(
              onTap: () {
                immersiveController.play(song);
              },
              child: SongSelectOption(
                highLight: playingSongMid == song.uid,
                coverUrl: song.album?.cover ?? "",
                fontSize: 12,
                subtitleFontSize: 12,
                thumbSize: 44,
                thumbPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                thumbMargin: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                thumbBorderRadius: 4,
                title: song.name,
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
  }
}
