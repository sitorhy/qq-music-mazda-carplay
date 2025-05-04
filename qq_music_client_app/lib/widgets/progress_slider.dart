import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/utils/duration_ext.dart';
import 'dart:math' as math;

class ProgressSlider extends StatefulWidget {
  final double height;
  final Axis direction;
  final Duration duration;
  final Duration current;
  final double progress; // 实际进度
  final double bufferedProgress; // 缓存进度
  final bool disabled;
  final void Function(double progress)? onSeeking;

  const ProgressSlider({
    super.key,
    this.height = 8,
    this.direction = Axis.horizontal,
    this.duration = Duration.zero,
    this.current = Duration.zero,
    this.progress = 0,
    this.disabled = false,
    this.bufferedProgress = 0,
    this.onSeeking,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProgressSliderState();
  }
}

class _ProgressSliderState extends State<ProgressSlider> {
  double maxSliderWidth = 0.0;
  double keepingDx = 0.0;
  bool isTouching = false;

  @override
  Widget build(BuildContext context) {
    var slider = Container(
      margin: widget.direction == Axis.horizontal
          ? const EdgeInsets.fromLTRB(12, 0, 12, 0)
          : const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(widget.height / 2)),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  maxSliderWidth = constraints.maxWidth;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                          BorderRadius.all(Radius.circular(widget.height / 2)),
                    ),
                    height: widget.height,
                  );
                },
              ),
              SizedBox(
                width: widget.bufferedProgress * maxSliderWidth,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ClientColors.focus,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  height: widget.height,
                ),
              ),
              SizedBox(
                width:
                    !isTouching ? widget.progress * maxSliderWidth : keepingDx,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.disabled
                        ? Colors.redAccent
                        : ClientColors.sliderColor,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                  ),
                  height: widget.height,
                ),
              ),
            ],
          ),
        ),
        onPanDown: (details) {
          if (widget.disabled) {
            return;
          }
          // 按下
          setState(() {
            isTouching = true;
            keepingDx =
                math.min(math.max(0, details.localPosition.dx), maxSliderWidth);
          });
        },
        onPanStart: (details) {
          if (widget.disabled) {
            return;
          }
          // 开始拖动
          setState(() {
            keepingDx =
                math.min(math.max(0, details.localPosition.dx), maxSliderWidth);
          });
        },
        onPanUpdate: (details) {
          if (widget.disabled) {
            return;
          }
          setState(() {
            keepingDx =
                math.min(math.max(0, details.localPosition.dx), maxSliderWidth);
          });
        },
        onPanEnd: (details) {
          if (widget.disabled) {
            return;
          }
          setState(() {
            isTouching = false;
          });
          if (widget.onSeeking != null) {
            widget.onSeeking!(keepingDx / maxSliderWidth);
          }
        },
        onPanCancel: () {
          if (widget.disabled) {
            return;
          }
          setState(() {
            isTouching = false;
          });
        },
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
              Text(
                widget.current.toSongDurationFormat(),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                widget.duration.toSongDurationFormat(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.current.toSongDurationFormat(),
          style: const TextStyle(fontSize: 12),
        ),
        Expanded(child: slider),
        Text(
          widget.duration.toSongDurationFormat(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
