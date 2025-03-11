import 'package:flutter/material.dart';
import 'package:qq_music_client_app/router/client_router_delegate.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_song_button.dart';
import 'package:qq_music_client_app/widgets/carousel_rich_text.dart';

class HomeViewFooterSong extends StatelessWidget {
  final double height;

  const HomeViewFooterSong({super.key, this.height = 40});

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
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      "images/cover.png",
                      width: height,
                      height: height,
                    ),
                  ),
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CarouselRichText(
                          title:
                              "Get Over The Barrier! -Roaring Version- (「英雄伝説 零の軌跡」)",
                        ),
                      ),
                      Flexible(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "Falcom Sound Team J.D.K.",
                          style: TextStyle(
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
        const Row(
          children: [
            HomeViewFooterSongButton(
              icon: Icons.favorite,
            ),
          ],
        ),
      ],
    );
  }
}
