import 'package:flutter/material.dart';
import 'dart:math' as math;

class _MeasureSize {
  bool measured = false; // 是否已测量，false表示在build阶段
  Size size = Size.zero;
}

class PositionedSingleScrollController extends ScrollController {
  int _limit = 0;
  List<_MeasureSize> _sizes = [];
  final Duration _duration;
  final Axis _direction;
  double clientHeight = 0;
  double clientWidth = 0;
  EdgeInsets clientPadding = EdgeInsets.zero;
  int _highlightIndex = -1;

  PositionedSingleScrollController({
    required Axis direction,
    Duration duration = const Duration(milliseconds: 300),
  })  : _direction = direction,
        _duration = duration;

  // 开辟空间
  void prepareMeasure({
    required int index,
  }) {
    while (index >= _limit) {
      _sizes.add(_MeasureSize());
    }
    _sizes[index].measured = false;
    _sizes[index].size = Size.zero;
  }

  // 回填尺寸
  void backpathMeasure({
    required int index,
    required Size size,
  }) {
    _sizes[index].measured = true;
    _sizes[index].size = size;
  }

  // 刷新列表元素数目
  void allocateMeasuresSize(int childrenSize) {
    if (_sizes.length < childrenSize) {
      _sizes.addAll(
        List.generate(childrenSize - _sizes.length, (index) {
          return _MeasureSize();
        })
      );
    }
    _limit = childrenSize;
  }

  void reset() {
    _sizes = [];
    _highlightIndex = -1;
    clientHeight = 0;
    clientWidth = 0;
    clientPadding = EdgeInsets.zero;
  }

  double _calcPosition(int index, Axis direction) {
    double total = 0;
    for (int i = 0; i < math.min(index, _limit); i++) {
      Size? size = _sizes[i].size;
      total += direction == Axis.vertical ? size.height : size.width;
    }
    total -= (direction == Axis.vertical ? clientHeight / 2 : clientWidth / 2);
    if (index < _limit) {
      Size target = _sizes[index].size;
      total += (direction == Axis.vertical ? target.height : target.width) / 2;
    }
    total +=
        direction == Axis.vertical ? clientPadding.top : clientPadding.left;
    return math.max(total, 0);
  }

  animateToIndex(int index) async {
    double offset = _calcPosition(index, _direction);
    await animateTo(offset, duration: _duration, curve: Curves.easeOutQuart);
    highlightIndex = math.min(index, _limit - 1);
  }

  jumpToIndex(int index) {
    double offset = _calcPosition(index, _direction);
    jumpTo(offset);
    highlightIndex = math.min(index, _limit - 1);
  }

  setClientSize(double width, double height) {
    clientWidth = width;
    clientHeight = height;
  }

  setClientPadding(EdgeInsets padding) {
    clientPadding = padding;
  }

  int get highlightIndex => _highlightIndex;

  set highlightIndex(int value) {
    _highlightIndex = value;
    notifyListeners();
  }
}
