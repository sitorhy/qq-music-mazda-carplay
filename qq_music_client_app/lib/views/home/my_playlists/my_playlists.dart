import 'package:flutter/cupertino.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class MyPlaylists extends StatelessWidget {
  const MyPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    var albumList = PositionedListView.separated(
      itemCount: 20,
      separatorExtent: 5,
      itemBuilder: (buildContext, index) {
        return PositionedListItem(
          index: index,
          child: const AlbumSelectOption(
            fontSize: 15,
            subtitleFontSize: 12,
            title: "带我去找夜生活",
            description: "告五人",
          ),
        );
      },
    );

    var songList = PositionedListView.separated(
      itemCount: 20,
      separatorExtent: 4.0,
      itemBuilder: (buildContext, index) {
        return PositionedListItem(
          index: index,
          child: const SongSelectOption(
            coverUrl: "images/cover.png",
            fontSize: 15,
            subtitleFontSize: 12,
            thumbSize: 54,
            title: "アインヘル小要塞",
            singer: "Falcom Sound Team J.D.K.",
            album: "英雄伝説 閃の軌跡III オリジナルサウンドトラック【上下巻】～完全版～",
            duration: Duration(seconds: 156),
          ),
        );
      },
    );

    return HomeContentContainer(
      child: Row(
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
    );
  }
}
