import 'package:flutter/material.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';
import 'package:qq_music_client_app/widgets/title_divider.dart';

class Recommendation extends StatelessWidget {
  const Recommendation({super.key});

  @override
  Widget build(BuildContext context) {
    var albumList = const PositionedSingleScrollView(children: [
      PositionedSingleScrollItem(
        child: TitleDivider(
          title: "Daily 30",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "每天30首",
          description: "日推",
        ),
      ),
      PositionedSingleScrollItem(
        child: TitleDivider(
          title: "歌单推荐",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "原声合集 | 电脑线圈",
          description: "日语",
        ),
      ),
      PositionedSingleScrollItem(
        child: AlbumSelectOption(
          looseDescription: true,
          fontSize: 15,
          subtitleFontSize: 12,
          title: "银之匙 | 原声合集",
          description: "日语",
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