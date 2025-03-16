import 'package:flutter/material.dart';
import 'package:qq_music_client_app/views/home/category_list.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';

class MyFavouritePlaylists extends StatelessWidget {
  const MyFavouritePlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    var albumList = const PositionedSingleScrollView(children: [
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "反向默契",
          description: "李柯君",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "没有你我也可以过得好",
          description: "洋澜一",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "新春福到丨蛇年行大运",
          description: "Q音车载小小编",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "哔哩哔哩官方ACG精选",
          description: "bilibili音乐",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "Strategy",
          description: "Olivia Marsh",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "Fire Cry",
          description: "分享Nicholas Witt",
        ),
      ),
    ]);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CategoryList(
            categories: [
              Category(title: "收藏的歌单"),
              Category(title: "收藏的专辑"),
            ],
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