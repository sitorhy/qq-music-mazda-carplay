import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/store/home_controller.dart';
import 'package:qq_music_client_app/utils/toast.dart';
import 'package:qq_music_client_app/views/home/category_list.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
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
    var songList = Obx(() {
      if ([0].contains(homeController.tagGroupIndex.value)) {
        return PositionedListView.separated(
          itemCount: homeController.recommendSongs.length,
          separatorExtent: 4.0,
          itemBuilder: (buildContext, index) {
            var song = homeController.recommendSongs[index];
            return PositionedListItem(
              index: index,
              child: SongSelectOption(
                coverUrl: song.album?.cover ?? "",
                fontSize: 15,
                subtitleFontSize: 12,
                thumbSize: 54,
                title: song.title,
                singer: song.singer.map((i) => i.name).join("/"),
                album: song.album?.name ?? "",
              ),
            );
          },
        );
      } else {
        List<Album> albums;
        switch (homeController.tagGroupIndex.value) {
          case 1:
            albums = homeController.newSongAlbums;
            break;
          case 2:
            albums = homeController.newAlbums;
            break;
          case 3:
            albums = homeController.topAlbums;
            break;
          default:
            albums = [];
        }
        return PositionedListView.separated(
          itemCount: albums.length,
          separatorExtent: 4.0,
          itemBuilder: (buildContext, index) {
            var album = albums[index];
            return PositionedListItem(
              index: index,
              child: SongSelectOption(
                coverUrl: album.cover ?? "",
                fontSize: 15,
                subtitleFontSize: 12,
                thumbSize: 54,
                title: album.name,
                singer: (album.singers ?? []).map((i) => i.name).join("/"),
                album: album.description ?? "",
              ),
            );
          },
        );
      }
    });

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
                            String recommendPlaylistId =
                                homeController.recommendPlaylistId.value;
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
                                  children.add(
                                    PositionedSingleScrollItem(
                                      child: GestureDetector(
                                        onTapDown: (detail) {
                                          homeController
                                              .setFocusedRecommendPlaylist(
                                                  playlist);
                                        },
                                        child: AlbumSelectOption(
                                          looseDescription: true,
                                          fontSize: 15,
                                          subtitleFontSize: 12,
                                          title: playlist.name,
                                          description: playlist.nickname ?? "",
                                          status: recommendPlaylistId ==
                                                  playlist.uid
                                              ? AlbumSelectOptionStatus.active
                                              : AlbumSelectOptionStatus.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                          break;
                        case 1:
                          {
                            String newSongTagId =
                                homeController.newSongTagId.value;
                            for (var tag in homeController.newSongAlbumTags) {
                              children.add(
                                PositionedSingleScrollItem(
                                  child: GestureDetector(
                                    onTap: () {
                                      homeController.setFocusedNewSongTag(tag);
                                    },
                                    child: AlbumSelectOption(
                                      status: newSongTagId == tag.uid
                                          ? AlbumSelectOptionStatus.active
                                          : AlbumSelectOptionStatus.normal,
                                      looseDescription: true,
                                      fontSize: 15,
                                      subtitleFontSize: 12,
                                      title: tag.tagName,
                                      description: "",
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          break;
                        case 2:
                          {
                            String newAlbumTagId =
                                homeController.newAlbumTagId.value;
                            for (var tag in homeController.newAlbumTags) {
                              children.add(
                                PositionedSingleScrollItem(
                                  child: GestureDetector(
                                    onTap: () {
                                      homeController.setFocusedNewAlbumTag(tag);
                                    },
                                    child: AlbumSelectOption(
                                      status: newAlbumTagId == tag.uid
                                          ? AlbumSelectOptionStatus.active
                                          : AlbumSelectOptionStatus.normal,
                                      looseDescription: true,
                                      fontSize: 15,
                                      subtitleFontSize: 12,
                                      title: tag.tagName,
                                      description: "",
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          break;
                        case 3:
                          {
                            String topAlbumTagId =
                                homeController.topAlbumTagId.value;
                            for (var tag in homeController.topAlbumTags) {
                              children.add(
                                PositionedSingleScrollItem(
                                  child: GestureDetector(
                                    onTap: () {
                                      homeController.setFocusedTopAlbumTag(tag);
                                    },
                                    child: AlbumSelectOption(
                                      status: topAlbumTagId == tag.uid
                                          ? AlbumSelectOptionStatus.active
                                          : AlbumSelectOptionStatus.normal,
                                      looseDescription: true,
                                      fontSize: 15,
                                      subtitleFontSize: 12,
                                      title: tag.tagName,
                                      description: "",
                                    ),
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
