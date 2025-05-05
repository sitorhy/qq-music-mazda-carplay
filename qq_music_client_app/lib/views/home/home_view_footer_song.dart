import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/router/client_router_delegate.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_song_button.dart';
import 'package:qq_music_client_app/widgets/carousel_rich_text.dart';

class HomeViewFooterSong extends StatelessWidget {
  final double height;
  final String coverUrl;
  final String title;
  final String author;
  final bool favBtnOutline;
  final bool favDisabled;
  final void Function(bool outline)? onFavClick;

  const HomeViewFooterSong({
    super.key,
    this.height = 40,
    this.coverUrl = "",
    this.title = "",
    this.author = "",
    this.favBtnOutline = true,
    this.favDisabled = true,
    this.onFavClick,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              ClientRouterDelegate.of(context).push("/immersive");
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 1, 8, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: coverUrl.startsWith("http")
                        ? CachedNetworkImage(
                            imageUrl: coverUrl,
                            placeholder: (context, url) =>
                                Image.asset("images/cd_default.png"),
                            errorWidget: (context, url, error) =>
                                Image.asset("images/cd_default.png"),
                          )
                        : Image.asset("images/cd_default.png"),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CarouselRichText(
                          title: title.isNotEmpty ? title : "QQ音乐 听我想听",
                        ),
                      ),
                      Flexible(
                        child: Text(
                          author.isNotEmpty ? author : "未知歌手",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: ClientColors.subtitle),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (favDisabled) {
                  return;
                }
                if (onFavClick != null) {
                  onFavClick!(favBtnOutline);
                }
              },
              child: HomeViewFooterSongButton(
                color: Colors.red,
                disabled: favDisabled,
                icon: favBtnOutline ? Icons.favorite_outline : Icons.favorite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
