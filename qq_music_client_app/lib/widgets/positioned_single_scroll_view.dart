import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_controller.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/sized_single_scroll_item.dart';

class PositionedSingleScrollView extends StatefulWidget {
  final PositionedSingleScrollController? controller;
  final List<PositionedSingleScrollItem> children;
  final CrossAxisAlignment crossAxisAlignment;

  final Key? listViewKey;
  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsets? padding;
  final bool? primary;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final HitTestBehavior hitTestBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const PositionedSingleScrollView({
    super.key,
    this.listViewKey,
    this.scrollDirection = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    required this.children,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  State<StatefulWidget> createState() {
    return _PositionedSingleScrollViewState();
  }
}

class _PositionedSingleScrollViewState
    extends State<PositionedSingleScrollView> {
  @override
  Widget build(BuildContext context) {
    widget.controller?.allocateMeasuresSize(widget.children.length);
    if (widget.padding != null) {
      widget.controller?.setClientPadding(widget.padding!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        widget.controller
            ?.setClientSize(constraints.maxWidth, constraints.maxHeight);
        return NotificationListener<SizedSingleScrollItemLayoutNotification>(
          child: SingleChildScrollView(
            key: widget.listViewKey,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            padding: widget.padding,
            primary: widget.primary,
            physics: widget.physics,
            controller: widget.controller,
            dragStartBehavior: widget.dragStartBehavior,
            clipBehavior: widget.clipBehavior,
            hitTestBehavior: widget.hitTestBehavior,
            restorationId: widget.restorationId,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            child: Flex(
              crossAxisAlignment: widget.crossAxisAlignment,
              direction: widget.scrollDirection,
              children: widget.children.mapIndexed((index, child) {
                print("${index} 构建");
                widget.controller?.prepareMeasure(index: index);
                return SizedSingleScrollItem(
                    index: index, tag: child.tag, child: child);
              }).toList(),
            ),
          ),
          onNotification: (notification) {
            print("${notification.index} 测量完毕 ${notification.size}");
            widget.controller?.backpathMeasure(
                index: notification.index, size: notification.size);
            return true;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.reset();
  }
}
