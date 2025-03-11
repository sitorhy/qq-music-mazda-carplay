import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CircleCover extends StatefulWidget {
  final double size;

  const CircleCover({super.key, this.size = 200});

  @override
  State<StatefulWidget> createState() {
    return _CircleCoverState();
  }
}

class _CircleCoverState extends State<CircleCover> with SingleTickerProviderStateMixin {
  ui.Image? cover;
  ui.Image? mask;
  ui.Image? foreground;
  late AnimationController controller = AnimationController(vsync: this);
  late Animation animation;

  @override
  void initState() {
    super.initState();
    Future.wait([
      loadImage("images/cover.png"),
      loadImage("images/cd_mask.png"),
      loadImage("images/cd_foreground.png")
    ]).then((result) {
      cover = result[0];
      mask = result[1];
      foreground = result[2];
      setState(() {});
    });

    controller.duration = const Duration(seconds: 60);
    Tween<double> tween = Tween(begin: 0, end: 360);
    animation = tween.animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: animation.value * math.pi / 180,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _CDPainter(cover: cover, foreground: foreground, mask: mask),
      ),
    );
  }

  @override
  void dispose() {
    controller.stop(canceled: true);
    super.dispose();
    controller.dispose();
  }
}

Future loadImage(String path) async {
  // 加载资源文件
  final data = await rootBundle.load(path);
  // 把资源文件转换成Uint8List类型
  final bytes = data.buffer.asUint8List();
  // 解析Uint8List类型的数据图片
  final image = await decodeImageFromList(bytes);
  return image;
}

class _CDPainter extends CustomPainter {
  ui.Image? cover;
  ui.Image? mask;
  ui.Image? foreground;

  _CDPainter({this.cover, this.mask, this.foreground});

  @override
  void paint(Canvas canvas, Size size) {
    if (cover != null) {
      ui.Rect areaRect = ui.Rect.fromLTWH(
        (size.width - math.min(size.width, size.height)) / 2,
        (size.height - math.min(size.width, size.height)) / 2,
        math.min(size.width, size.height),
        math.min(size.width, size.height),
      );
      Paint paint = Paint();
      canvas.saveLayer(ui.Rect.fromLTWH(0, 0, size.width, size.height), paint);

      canvas.drawImageRect(
        cover!,
        ui.Rect.fromLTWH(
          0,
          0,
          cover!.width.toDouble(),
          cover!.height.toDouble(),
        ),
        areaRect,
        paint,
      );

      paint.blendMode = ui.BlendMode.dstIn;

      canvas.drawImageRect(
        mask!,
        ui.Rect.fromLTWH(
          0,
          0,
          mask!.width.toDouble(),
          mask!.height.toDouble(),
        ),
        areaRect,
        paint,
      );

      paint.blendMode = BlendMode.srcOver;

      canvas.drawImageRect(
        foreground!,
        ui.Rect.fromLTWH(
          0,
          0,
          foreground!.width.toDouble(),
          foreground!.height.toDouble(),
        ),
        areaRect,
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CDPainter oldDelegate) {
    return oldDelegate.cover != cover ||
        oldDelegate.foreground != foreground ||
        oldDelegate.mask != mask;
  }
}
