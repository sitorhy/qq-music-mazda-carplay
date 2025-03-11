import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/utils/duration_ext.dart';

class SongSelectOption extends StatelessWidget {
  final String coverUrl;
  final double fontSize;
  final double subtitleFontSize;
  final String title;
  final String singer;
  final String album;
  final Duration duration;
  final double thumbSize;

  const SongSelectOption({
    super.key,
    this.coverUrl = "",
    this.fontSize = 20,
    this.subtitleFontSize = 12,
    this.title = "歌曲名称",
    this.singer = "艺术家",
    this.album = "专辑名称",
    this.thumbSize = 64.0,
    this.duration = const Duration(seconds: 0),
  });

  @override
  Widget build(BuildContext context) {
    var songInfo = Row(
      children: [
        Expanded(
          flex: 12,
          child: Container(
            // decoration: BoxDecoration(color: Colors.yellow),
            padding: EdgeInsets.only(right: fontSize, left: thumbSize + fontSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 5, maxHeight: 5),
                ),
                Text(
                  singer,
                  style: TextStyle(fontSize: subtitleFontSize),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: Container(
            // decoration: BoxDecoration(color: Colors.green),
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              album,
              style: TextStyle(fontSize: subtitleFontSize),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            // decoration: BoxDecoration(color: Colors.blue),
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              duration.toSongDurationFormat(),
              style: TextStyle(fontSize: subtitleFontSize),
            ),
          ),
        )
      ],
    );

    var songCover = Image.asset(
      coverUrl,
      width: thumbSize,
      height: thumbSize,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
    );

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        color: ClientColors.text,
        overflow: TextOverflow.ellipsis,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: ClientColors.lightPrimary,
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            songCover,
            songInfo,
          ],
        ),
      ),
    );
  }
}
