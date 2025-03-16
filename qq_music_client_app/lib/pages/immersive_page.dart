import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qq_music_client_app/router/client_router_delegate.dart';
import 'package:qq_music_client_app/views/immersive/circle_cover.dart';
import 'package:qq_music_client_app/views/immersive/play_controls.dart';
import 'package:qq_music_client_app/widgets/carousel_rich_text.dart';
import 'package:qq_music_client_app/widgets/lyrics_renderer.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_controller.dart';
import 'package:qq_music_client_app/widgets/progress_slider.dart';

class _ImmersivePage extends StatefulWidget {
  final Animation? animation;

  const _ImmersivePage({this.animation});

  @override
  State<StatefulWidget> createState() {
    return _ImmersivePageState();
  }
}

class _ImmersivePageState extends State<_ImmersivePage>
    with TickerProviderStateMixin {
  late AnimationController leftAnimationController;
  late AnimationController rightAnimationController;

  @override
  void initState() {
    super.initState();
    widget.animation?.addStatusListener(routeAnimationStatusChanged);
    leftAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    CurvedAnimation(parent: leftAnimationController, curve: Curves.easeOut);
    leftAnimationController.addListener(() {
      setState(() {});
    });
    leftAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rightAnimationController.forward(from: 0.0);
      }
    });
    rightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    rightAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.animation?.removeStatusListener(routeAnimationStatusChanged);
  }

  void routeAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      leftAnimationController.forward(from: 0.0);
    }
  }

  PositionedSingleScrollController controller =
      PositionedSingleScrollController(direction: Axis.vertical);

  @override
  Widget build(BuildContext context) {
    var pageHeader = FractionallySizedBox(
      widthFactor: 1850 / 1945,
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: const Icon(
                color: Colors.white70,
                IconData(0xe84c, fontFamily: "IconFont"),
              ),
              onTap: () {
                ClientRouterDelegate.of(context).pop();
              },
            ),
            const Icon(
              color: Colors.white70,
              IconData(0xe643, fontFamily: "IconFont"),
            ),
          ],
        ),
      ),
    );

    var pageFooter = Container(
      // decoration: const BoxDecoration(color: Colors.white24),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: PlayControls(),
      ),
    );

    var leftWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: CircleCover(
            size: 180,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: LayoutBuilder(builder: (c, s) {
                  String title = "夏日漱石 (Summer Cozy Rock)";
                  final TextPainter textPainter = TextPainter(
                      text: TextSpan(
                        text: title,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr)
                    ..layout(minWidth: 0, maxWidth: double.infinity);

                  return Container(
                    height: textPainter.height,
                    // decoration: BoxDecoration(color: Colors.yellow),
                    child: CarouselRichText(
                      titleColor: Colors.white,
                      titleSize: 15,
                      title: title,
                    ),
                  );
                }),
              ),
              const SizedBox(
                width: 15,
              ),
              const Icon(
                color: Colors.white70,
                IconData(0xe601, fontFamily: "IconFont"),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: const Text(
            "Fly By Midnight / Rachel Grae",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: ProgressSlider(
            height: 6,
            direction: Axis.horizontal,
          ),
        ),
        pageFooter,
      ],
    );

    var rightWidget = Expanded(
      flex: 9,
      child: Column(
        children: [
          Expanded(
            child: Opacity(
              opacity: rightAnimationController.value,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.0),
                      Color.fromRGBO(0, 0, 0, 0.65),
                      Color.fromRGBO(0, 0, 0, 0.9),
                      Color.fromRGBO(0, 0, 0, 1.0),
                      Color.fromRGBO(0, 0, 0, 1.0),
                      Color.fromRGBO(0, 0, 0, 0.9),
                      Color.fromRGBO(0, 0, 0, 0.65),
                      Color.fromRGBO(0, 0, 0, 0.0),
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: LyricsRenderer(
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    var pageBody = FractionallySizedBox(
      widthFactor: 1850 / 1945,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Transform.translate(
              offset: Offset((1.0 - leftAnimationController.value) * -50, 0),
              child: Opacity(
                opacity: (leftAnimationController.value),
                child: leftWidget,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          rightWidget,
        ],
      ),
    );

    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        fontSize: 22,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/cover.png', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 80,
                sigmaY: 80,
                tileMode: TileMode.clamp,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black26, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                pageHeader,
                Expanded(child: pageBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImmersivePage extends Page {
  const ImmersivePage({super.key});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _ImmersivePage(
          animation: animation,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.linearToEaseOut;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
