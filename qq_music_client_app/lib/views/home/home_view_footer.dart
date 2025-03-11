import 'package:flutter/material.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_player.dart';
import 'package:qq_music_client_app/widgets/progress_slider.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_song.dart';

class HomeViewFooter extends StatelessWidget {
  const HomeViewFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 35,
          child: HomeViewFooterSong(height: 38),
        ),
        Expanded(
          flex: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(),
          ),
        ),
        Expanded(
          flex: 30,
          child: HomeViewFooterPlayer(height: 38),
        ),
        Expanded(
          flex: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(),
          ),
        ),
        Expanded(
          flex: 33,
          child: ProgressSlider(),
        ),
      ],
    );
  }
}
