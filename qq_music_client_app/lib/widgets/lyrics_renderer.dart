import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_controller.dart';
import 'dart:math' as math;

import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';

class LyricsRenderer extends StatefulWidget {
  final double fontSize;
  final double fontSizeHighlight;
  final Color fontColor;
  final Color fontColorHighlight;
  final PositionedSingleScrollController? controller;
  final bool _debugShowIndex = false;

  const LyricsRenderer({
    super.key,
    this.fontSize = 15.0,
    this.fontColor = Colors.white,
    this.controller,
    this.fontSizeHighlight = 16.0,
    this.fontColorHighlight = Colors.yellow,
  });

  @override
  State<StatefulWidget> createState() {
    return _LyricsRendererState();
  }
}

class _LyricsRendererState extends State<LyricsRenderer> {
  _LyricsManager lyricsManager = _LyricsManager(text: "");
  List<List<_LyricTag>> groupTimeLines = [];
  int highlightIndex = -1;

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString("lyrics/希望有羽毛和翅膀 - 知更鸟,HOYO-MiX,Chevy.lrc")
        .then((lyrics) {
      lyricsManager = _LyricsManager(text: lyrics);
      lyricsManager.addListener(() {
        setState(() {
          groupTimeLines = lyricsManager.groupTimeLines;
        });
      });
      lyricsManager.rebuild();
    });
    widget.controller?.addListener(onControllerNotice);
  }

  void onControllerNotice() {
    if (highlightIndex != widget.controller?.highlightIndex) {
      setState(() {
        highlightIndex = widget.controller?.highlightIndex ?? -1;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onControllerNotice);
    super.dispose();
  }

  Widget _renderList(BoxConstraints constraints) {
    // 基准文字尺寸，用于行间隔
    var lyricTextStyle = TextStyle(
      color: widget.fontColor,
      fontSize: widget.fontSize,
      decoration: TextDecoration.none,
    );
    Size measuredFontSize = _textSize("中おAa8@한", lyricTextStyle);

    var highlightTextStyle = TextStyle(
      color: widget.fontColorHighlight,
      fontSize: widget.fontSizeHighlight,
      decoration: TextDecoration.none,
    );
    // 高亮文字高度，与基准高度比较，预留高亮行间隔
    Size measuredHighlightFontSize = _textSize(
      "中おAa8@한",
      highlightTextStyle,
    );
    double dyHighlight =
        math.max(0, measuredHighlightFontSize.height - measuredFontSize.height);

    var children = groupTimeLines.mapIndexed((index, groupLines) {
      return PositionedSingleScrollItem(
        child: Container(
          // decoration: BoxDecoration(color: Colors.white12),
          padding: EdgeInsets.fromLTRB(
            0,
            (measuredFontSize.height + dyHighlight) / 2,
            0,
            (measuredFontSize.height + dyHighlight) / 2,
          ),
          child: Column(
            children: groupLines.map(
              (tag) {
                return Text(
                  textAlign: TextAlign.center,
                  widget._debugShowIndex
                      ? "$index.${tag.content}"
                      : tag.content,
                  style: highlightIndex == index ? highlightTextStyle : lyricTextStyle,
                );
              },
            ).toList(),
          ),
        ),
      );
    }).toList();

    return PositionedSingleScrollView(
      controller: widget.controller,
      padding: EdgeInsets.fromLTRB(
        0,
        constraints.maxHeight / 2 - (measuredFontSize.height),
        0,
        constraints.maxHeight / 2 - (measuredFontSize.height),
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 200,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        widget.controller?.setClientSize(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return _renderList(constraints);
      }),
    );
  }
}

class _LyricsManager extends ChangeNotifier {
  String _text = "";
  List<List<_LyricTag>> groupTimeLines = [];

  _LyricsManager({String? text}) {
    _text = text ?? "";
  }

  rebuild() {
    var tmp = _text.split("\n").map((lyric) {
      return _LyricTag(lyric.trim());
    });
    // 司马dart空安全不能将map生成的列表元素置空，只能分开写
    List<_LyricTag?> lines = [];
    lines.addAll(tmp);

    List<List<_LyricTag>> nextGroupTimeLines = [];
    for (int i = 0; i < lines.length; ++i) {
      _LyricTag? line = lines[i];
      if (line != null) {
        String strTime = line.strTime;
        if (strTime.isNotEmpty) {
          List<_LyricTag> group = [line];
          int sameTimeIndex = i;
          while (sameTimeIndex < lines.length) {
            sameTimeIndex = lines.indexWhere(
                (i) => i != null && i.strTime == strTime, sameTimeIndex + 1);
            if (sameTimeIndex >= 0) {
              group.add(lines[sameTimeIndex]!);
              lines[sameTimeIndex] = null;
            } else {
              sameTimeIndex = lines.length;
            }
          }
          nextGroupTimeLines.add(group);
        } else {
          nextGroupTimeLines.add([line]);
        }
      }
    }

    groupTimeLines = nextGroupTimeLines;

    notifyListeners();
  }
}

class _LyricTag {
  static RegExp lyricTagRegex = RegExp("\\[(.+)\\]");
  static RegExp lyricTimeRegex = RegExp("\\[((\\d+)\\.?(\\d+)?:?)+\\]");
  late String content = "";
  late String tag = "";
  late String strTime = "";
  late double seconds = 0;

  Duration? timestamp;

  _LyricTag(String lyric) {
    content = lyric;
    RegExpMatch? match = lyricTagRegex.firstMatch(content);
    if (match != null) {
      tag = match.group(0)!;
      if (tag.isNotEmpty) {
        content = content.substring(tag.length).trim();
      }
      RegExpMatch? timeMatch = lyricTimeRegex.firstMatch(tag);
      if (timeMatch != null) {
        tag = "";
        strTime = timeMatch.group(0)!;
        strTime = strTime.substring(1, strTime.length - 1);
        seconds = strTime.split(":").reversed.toList().mapIndexed((index, numStr) {
          return double.parse(numStr) * math.pow(60, index);
        }).reduce((s, e) {
          return s + e;
        });
        timestamp = Duration(seconds: seconds.round());
      } else {
        tag = tag.substring(1, tag.length - 1);
      }
    } else {
      tag = "";
    }
  }
}
