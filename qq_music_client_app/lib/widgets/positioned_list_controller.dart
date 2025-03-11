import 'package:flutter/material.dart';

class PositionedListController extends ScrollController {
  double listViewExtent = 0;
  double itemExtent = 0;
  double itemGap = 0;
  final Duration duration;

  PositionedListController({this.duration = const Duration(milliseconds: 300)});

  double _calcPosition(int index) {
    double totalItemExtent = itemExtent * (index + 1) + itemGap * index;
    double centerPosition =
        totalItemExtent - listViewExtent / 2 - itemExtent / 2;
    return centerPosition;
  }

  animateToIndex(int index) {
    double offset = _calcPosition(index);
    animateTo(offset,
        duration: duration, curve: Curves.easeOutQuart);
  }

  jumpToIndex(int index) {
    double offset = _calcPosition(index);
    jumpTo(offset);
  }
}
