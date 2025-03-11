import 'package:flutter/material.dart';

class SizedSingleScrollItem extends StatefulWidget {
  final int index;
  final Widget child;
  final String tag; // 自定义标记

  const SizedSingleScrollItem({
    super.key,
    this.tag = "",
    required this.child,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() {
    return _SizedSingleScrollItemState();
  }
}

class _SizedSingleScrollItemState extends State<SizedSingleScrollItem> {
  final GlobalKey _key = GlobalKey<_SizedSingleScrollItemState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      var renderObject = _key.currentContext?.findRenderObject();
      if (renderObject != null) {
        RenderBox renderBox = renderObject as RenderBox;
        Size size = renderBox.size;
        _key.currentContext!.dispatchNotification(SizedSingleScrollItemLayoutNotification(
          size: size,
          index: widget.index,
          tag: widget.tag,
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}

class SizedSingleScrollItemLayoutNotification extends Notification {
  final String tag; // 自定义标签
  final Size size;
  final int index;

  SizedSingleScrollItemLayoutNotification(
      {required this.size, required this.index, this.tag = ""});
}
