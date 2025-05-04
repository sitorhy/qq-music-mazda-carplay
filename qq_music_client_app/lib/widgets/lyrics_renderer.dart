import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_controller.dart';
import 'dart:math' as math;

import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';

class LyricsRenderer extends StatefulWidget {
  final double fontSize;
  final double fontSizeHighlight;
  final Color fontColor;
  final Color fontColorHighlight;
  final String lyricText;
  final Duration current;

  // 测试用，显示行号
  final bool _debugShowIndex = false;

  const LyricsRenderer({
    super.key,
    this.fontSize = 15.0,
    this.fontColor = Colors.white,
    this.fontSizeHighlight = 16.0,
    this.fontColorHighlight = Colors.yellow,
    this.lyricText = "",
    this.current = Duration.zero,
  });

  @override
  State<StatefulWidget> createState() {
    return _LyricsRendererState();
  }
}

class _LyricsRendererState extends State<LyricsRenderer> {
  _LyricsManager lyricsManager = _LyricsManager(text: "");
  PositionedSingleScrollController controller =
      PositionedSingleScrollController(direction: Axis.vertical);
  List<List<_LyricTag>> groupTimeLines = [];
  int highlightIndex = 0;

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
    lyricsManager = _LyricsManager(text: widget.lyricText);
    lyricsManager.addListener(() {
      setState(() {
        groupTimeLines = lyricsManager.groupTimeLines;
      });
      print(groupTimeLines);
    });
    lyricsManager.rebuild();
  }

  @override
  void didUpdateWidget(LyricsRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lyricText != widget.lyricText) {
      lyricsManager._text = widget.lyricText;
      highlightIndex = 0; // 临时变量不需要触发setState
      lyricsManager.rebuild();
    }
    if (widget.current != oldWidget.current) {
      // 播放进度更新 更新歌词高亮行
      int index = 0;
      int nextHighLightIndex = groupTimeLines.indexWhere((lines) {
        var rightTag =
            groupTimeLines[math.min(groupTimeLines.length - 1, index + 1)]
                .elementAt(0);
        var leftTag = lines.elementAt(0);
        if (leftTag.seconds <= widget.current.inSeconds &&
            widget.current.inSeconds < rightTag.seconds) {
          return true;
        } else if (leftTag == rightTag) {
          // 已经搜索到结尾
          return true;
        }
        index++;
        return false;
      });
      if (highlightIndex != nextHighLightIndex && nextHighLightIndex >= 0) {
        highlightIndex = nextHighLightIndex;
        controller.animateToIndex(highlightIndex);
      }
    }
  }

  @override
  void dispose() {
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
      // 是否背景音乐过渡行（没有歌词的行）
      bool isEmptyLine = groupLines.every((i) => i.content.isEmpty);

      return PositionedSingleScrollItem(
        child: Container(
          // 过渡行尺寸直接0
          padding: EdgeInsets.fromLTRB(
            0,
            isEmptyLine ? 0 : (measuredFontSize.height + dyHighlight) / 2,
            0,
            isEmptyLine ? 0 : (measuredFontSize.height + dyHighlight) / 2,
          ),
          child: isEmptyLine
              ? const SizedBox(
                  height: 0,
                )
              : Column(
                  children: groupLines.map(
                    (tag) {
                      return Text(
                        textAlign: TextAlign.center,
                        widget._debugShowIndex
                            ? "$index.${tag.content}"
                            : tag.content,
                        style: highlightIndex == index
                            ? highlightTextStyle
                            : lyricTextStyle,
                      );
                    },
                  ).toList(),
                ),
        ),
      );
    }).toList();

    return PositionedSingleScrollView(
      listViewKey: ObjectKey(widget.lyricText),
      controller: controller,
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
        controller.setClientSize(
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

    // 填充非时间轴行，平均分配时间轴（作者，标题等）
    _writeNonTimeTagFrames(nextGroupTimeLines);

    groupTimeLines = nextGroupTimeLines;

    notifyListeners();
  }

  _writeNonTimeTagFrames(List<List<_LyricTag>> groupTimeLines) {
    // 非时间轴行
    int left = groupTimeLines
        .indexWhere((group) => group.elementAt(0).strTime.isEmpty);
    // 最近的时间轴行
    int right = left;

    if (left < 0) {
      return;
    }

    while (left < groupTimeLines.length && right < groupTimeLines.length) {
      // 查找下一个最近的时间轴行
      int nextRight = groupTimeLines.indexWhere(
          (group) => group.elementAt(0).strTime.isNotEmpty, left);

      if (nextRight >= 0) {
        // 存在空白的排轴片段
        right = nextRight;
      } else {
        break;
      }

      // 平均分配片段时间排轴
      for (int i = left; i < right; ++i) {
        for (var tag in groupTimeLines[i]) {
          tag.seconds = ((groupTimeLines[right].elementAt(0).seconds -
                          groupTimeLines[left].elementAt(0).seconds) /
                      (right - left)) *
                  (i - left) +
              groupTimeLines[left].elementAt(0).seconds;
          tag.seconds = double.parse(tag.seconds.toStringAsFixed(2));
        }
      }
      int nextLeft = groupTimeLines.indexWhere(
          (group) => group.elementAt(0).strTime.isEmpty, right + 1);
      if (nextLeft < 0) {
        left = groupTimeLines.length;
      } else {
        left = nextLeft;
      }
    }
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
        seconds =
            strTime.split(":").reversed.toList().mapIndexed((index, numStr) {
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

  @override
  String toString() {
    return "{$seconds: ${content.isEmpty ? (tag.isEmpty ? 'EMPTY' : tag) : (content.isEmpty ? 'EMPTY' : content)}}";
  }
}
