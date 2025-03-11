import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'dart:math' as math;

class ProgressSlider extends StatefulWidget {
  final double height;
  final Axis direction;

  const ProgressSlider(
      {super.key, this.height = 8, this.direction = Axis.horizontal});

  @override
  State<StatefulWidget> createState() {
    return _ProgressSliderState();
  }
}

class _ProgressSliderState extends State<ProgressSlider> {
  Offset slideStartPosition = Offset.zero;
  Offset slideEndPosition = Offset.zero;
  double keepingProgress = 0.0;
  double maxSliderWidth = 0.0;
  double progress = 0.5;

  @override
  Widget build(BuildContext context) {
    var slider = Container(
      margin: widget.direction == Axis.horizontal
          ? EdgeInsets.fromLTRB(12, 0, 12, 0)
          : EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: GestureDetector(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                maxSliderWidth = constraints.maxWidth;
                return Container(
                  decoration: BoxDecoration(
                    color: ClientColors.focus,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.height / 2)),
                  ),
                  height: widget.height,
                );
              },
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: ClientColors.sliderColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.height / 2)),
                ),
                height: widget.height,
              ),
            )
          ],
        ),
        onPanStart: (details) {
          slideStartPosition = details.globalPosition;
          keepingProgress = progress;
        },
        onPanUpdate: (details) {
          slideEndPosition = details.globalPosition;
          double dx = slideEndPosition.dx - slideStartPosition.dx;
          double nextSliderWidth = dx + maxSliderWidth * keepingProgress;
          nextSliderWidth =
              math.min(math.max(nextSliderWidth, 0), maxSliderWidth);
          setState(() {
            progress = nextSliderWidth / maxSliderWidth;
          });
        },
        onPanEnd: (details) {
          slideEndPosition = details.globalPosition;
        },
        onPanCancel: () {},
      ),
    );

    if (widget.direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          slider,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "00:00",
                style: TextStyle(fontSize: 12),
              ),
              const Text(
                "00:00",
                style: TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "00:00",
          style: TextStyle(fontSize: 12),
        ),
        Expanded(child: slider),
        const Text(
          "00:00",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
