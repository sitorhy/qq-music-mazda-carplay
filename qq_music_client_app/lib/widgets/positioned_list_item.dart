import 'package:flutter/material.dart';

class PositionedListItem extends StatefulWidget {
  final Widget child;
  final int index;

  const PositionedListItem(
      {super.key, required this.child, required this.index});

  @override
  State<StatefulWidget> createState() {
    return _PositionedListItemState();
  }
}

class _PositionedListItemState extends State<PositionedListItem> {
  final GlobalKey _key = GlobalKey();
  Size? _boxSize;

  @override
  void didUpdateWidget(covariant PositionedListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_key.currentContext?.findRenderObject() != null) {
      RenderBox renderBox =
          _key.currentContext!.findRenderObject() as RenderBox;
      _boxSize = Size(renderBox.size.width, renderBox.size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_boxSize != null) {
      PositionedListItemLayoutNotification notification =
          PositionedListItemLayoutNotification(
              width: _boxSize!.width,
              height: _boxSize!.height,
              index: widget.index);
      notification.dispatch(context);
    }

    return Container(
      key: _key,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PositionedListItemLayoutNotification extends Notification {
  final double width;
  final double height;
  final int index;

  PositionedListItemLayoutNotification(
      {required this.width, required this.height, required this.index});
}
