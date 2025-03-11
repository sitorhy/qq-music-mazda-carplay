import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'dart:math' as math;

class CarouselRichText extends StatefulWidget {
  final String title;
  final String? subtitle;
  final double titleSize;
  final Color titleColor;
  final double subtitleSize;
  final Color subtitleColor;

  const CarouselRichText({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor = ClientColors.text,
    this.titleSize = 13,
    this.subtitleSize = 13,
    this.subtitleColor = ClientColors.subtitle,
  });

  @override
  State<StatefulWidget> createState() {
    return _CarouselRichTextState();
  }
}

class _CarouselRichTextState extends State<CarouselRichText>
    with SingleTickerProviderStateMixin {
  GlobalKey globalKey = GlobalKey();
  double containerWidth = 0.0;
  double offset = 0.0;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    controller.value = 0.0;
    controller.addListener(() {
      setState(() {
        offset = controller.value;
      });
    });
    controller.addStatusListener((AnimationStatus status) {
      if (status.isCompleted) {
        controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = [Text(widget.title)];
    List<Widget> textWidgetsRepeat = [Text(widget.title)];

    if (widget.subtitle != null && widget.subtitle!.isNotEmpty) {
      textWidgets.add(const Text(" - "));
      textWidgets.add(
        Text(
          widget.subtitle!,
          style: TextStyle(
            color: widget.subtitleColor,
            fontSize: widget.subtitleSize,
          ),
        ),
      );

      textWidgetsRepeat.add(const Text(" - "));
      textWidgetsRepeat.add(
        Text(
          widget.subtitle!,
          style: TextStyle(
            color: widget.subtitleColor,
            fontSize: widget.subtitleSize,
          ),
        ),
      );
    }

    return DefaultTextStyle(
      style: TextStyle(fontSize: widget.titleSize, color: widget.titleColor),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: CustomMultiChildLayout(
          delegate: _CarouseRichTextLayout(
            offset: offset,
            startScroll: (double layoutWidth) {
              controller.animateTo(1.0,
                  duration: Duration(
                      seconds: math.max(
                          10,
                          ((widget.title.length +
                                      (widget.subtitle?.length ?? 0)) /
                                  53 *
                                  10)
                              .toInt())),
                  curve: Curves.linear);
            },
            stopScroll: () {
              controller.stop();
            },
          ),
          children: [
            LayoutId(
              id: 1,
              child: Row(
                children: textWidgets,
              ),
            ),
            LayoutId(
              id: 2,
              child: Row(
                children: textWidgetsRepeat,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CarouseRichTextLayout extends MultiChildLayoutDelegate {
  final void Function(double width) startScroll;
  final void Function() stopScroll;
  final double offset;
  final double internal = 40;

  _CarouseRichTextLayout(
      {required this.startScroll,
      required this.stopScroll,
      required this.offset});

  @override
  void performLayout(Size size) {
    Size textLayoutSize = layoutChild(
      1,
      BoxConstraints.loose(Size(double.infinity, size.height)),
    );
    layoutChild(
      2,
      BoxConstraints.loose(Size(double.infinity, size.height)),
    );
    if (textLayoutSize.width < size.width) {
      positionChild(
        1,
        const Offset(0, 0),
      );
      positionChild(
        2,
        Offset(internal + size.width, 0),
      );
    } else {
      double dx = offset * (internal + textLayoutSize.width);
      positionChild(
        1,
        Offset(-dx, 0),
      );
      positionChild(
        2,
        Offset(internal + textLayoutSize.width - dx, 0),
      );
      if (offset == 0) {
        startScroll(textLayoutSize.width + internal);
      }
    }
  }

  @override
  bool shouldRelayout(covariant _CarouseRichTextLayout oldDelegate) {
    return offset != oldDelegate.offset;
  }
}
