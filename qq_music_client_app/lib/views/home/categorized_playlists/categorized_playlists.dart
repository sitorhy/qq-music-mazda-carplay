import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/home_controller.dart';
import 'package:qq_music_client_app/utils/toast.dart' show toastError;
import 'package:qq_music_client_app/views/home/category_list.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart'
    show AlbumSelectOption;
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/song_select_option.dart';
import 'package:qq_music_client_app/widgets/title_divider.dart';

class CategorizedPlaylists extends StatelessWidget {
  CategorizedPlaylists({super.key});

  final HomeController homeController = Get.find(tag: "homeController");

  @override
  Widget build(BuildContext context) {
    var songList = PositionedListView.separated(
      itemCount: 0,
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
          Obx(
            () => CategoryList(
              activeIndex: homeController.tagGroupIndex.value,
              categories: homeController.tagGroups.map((tagGroup) {
                return Category(title: tagGroup.tagGroupName);
              }).toList(),
              onActiveIndexChange: (index) {
                homeController.tagGroupIndex.value = index;
              },
            ),
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
                  child: Obx(() {
                    try {
                      List<PositionedSingleScrollItem> children = [];

                      switch (homeController.tagGroupIndex.value) {
                        case 0:
                          {
                            for (var tagPlaylist
                                in homeController.recommendTagPlaylists) {
                              if (tagPlaylist.playlists.isNotEmpty) {
                                if (tagPlaylist.tag != null) {
                                  children.add(
                                    PositionedSingleScrollItem(
                                      child: TitleDivider(
                                        title: tagPlaylist.tag!.tagName,
                                      ),
                                    ),
                                  );
                                }

                                for (var playlist in tagPlaylist.playlists) {
                                  children.add(PositionedSingleScrollItem(
                                    child: AlbumSelectOption(
                                      looseDescription: true,
                                      fontSize: 15,
                                      subtitleFontSize: 12,
                                      title: playlist.name,
                                      description:
                                          tagPlaylist.tag?.tagName ?? "",
                                    ),
                                  ));
                                }
                              }
                            }
                          }
                          break;
                        case 1:
                          {
                            for (var tag in homeController.newSongAlbumTags) {
                              children.add(
                                PositionedSingleScrollItem(
                                  child: AlbumSelectOption(
                                    looseDescription: true,
                                    fontSize: 15,
                                    subtitleFontSize: 12,
                                    title: tag.tagName,
                                    description: "",
                                  ),
                                ),
                              );
                            }
                          }
                          break;
                        case 2:
                          {
                            for (var tag in homeController.newAlbumTags) {
                              children.add(
                                PositionedSingleScrollItem(
                                  child: AlbumSelectOption(
                                    looseDescription: true,
                                    fontSize: 15,
                                    subtitleFontSize: 12,
                                    title: tag.tagName,
                                    description: "",
                                  ),
                                ),
                              );
                            }
                          }
                          break;
                      }

                      return PositionedSingleScrollView(children: children);
                    } catch (e) {
                      toastError(e);
                      return Container();
                    }
                  }),
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
