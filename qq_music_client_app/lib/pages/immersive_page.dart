import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/router/client_router_delegate.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/store/profile_controller.dart';
import 'package:qq_music_client_app/utils/songs.dart';
import 'package:qq_music_client_app/views/immersive/circle_cover.dart';
import 'package:qq_music_client_app/views/immersive/drawer_playlist.dart';
import 'package:qq_music_client_app/views/immersive/play_controls.dart';
import 'package:qq_music_client_app/widgets/carousel_rich_text.dart';
import 'package:qq_music_client_app/widgets/lyrics_renderer.dart';
import 'package:qq_music_client_app/widgets/progress_slider.dart';

// 播放页，使用动画必须使用 StatefulWidget
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

  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  final ProfileController profileController =
      Get.find(tag: "profileController");

  // final progressStream = BehaviorSubject<WaveformProgress>();

  @override
  void initState() {
    super.initState();
    widget.animation?.addStatusListener(routeAnimationStatusChanged);
    leftAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
      duration: const Duration(milliseconds: 200),
    );
    rightAnimationController.addListener(() {
      setState(() {});
    });

    onPlayingSongChange(immersiveController.playingSong.value);
    immersiveController.playingSong.listen(onPlayingSongChange);
  }

  void onPlayingSongChange(Song song) {
    if (song.songId > 0) {
      _resolveWave();
    }
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

  _resolveWave() async {
    // var song = immersiveController.playingSong.value;
    // var response =
    //     await FetchSongSourceRequest(songMid: song.songMid, songId: song.songId)
    //         .request();
    // String url = response.data ?? "";
    // try {
    //   String savePath = await LocalSongUtils.getSongCachePath(url);
    //   String wavePath = await LocalSongUtils.getSongWaveCachePath(url);
    //
    //   await HttpUtil.download(url, savePath);
    //   print("$savePath cache completed.");
    //
    //   JustWaveform.extract(
    //     audioInFile: File(savePath),
    //     waveOutFile: File(wavePath),
    //     zoom: const WaveformZoom.pixelsPerSecond(100),
    //   ).listen((waveformProgress) {
    //     print('Progress: %${(100 * waveformProgress.progress).toInt()}');
    //     if (waveformProgress.waveform != null) {
    //       // Use the waveform.
    //     }
    //     progressStream.add(waveformProgress);
    //   }, onError: progressStream.addError);
    // } catch (e) {
    //   toastError(e);
    // }
  }

  // Widget getWaveform() {
  //   return StreamBuilder<WaveformProgress>(
  //     stream: progressStream,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Center(
  //           child: Text(
  //             'Error: ${snapshot.error}',
  //             style: Theme.of(context).textTheme.titleLarge,
  //             textAlign: TextAlign.center,
  //           ),
  //         );
  //       }
  //       final progress = snapshot.data?.progress ?? 0.0;
  //       final waveform = snapshot.data?.waveform;
  //       if (waveform == null) {
  //         return Center(
  //           child: Text(
  //             '${(100 * progress).toInt()}%',
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //         );
  //       }
  //       return Obx(() {
  //         return AudioWaveformWidget(
  //           waveform: waveform,
  //           start: Duration.zero,
  //           duration: waveform.duration,
  //         );
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var pageHeader = FractionallySizedBox(
      widthFactor: 1850 / 1945,
      child: SizedBox(
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
            GestureDetector(
              child: const Icon(
                color: Colors.white70,
                IconData(0xe643, fontFamily: "IconFont"),
              ),
              onTap: () {
                final ScaffoldState? result =
                    context.findAncestorStateOfType<ScaffoldState>();
                if (result != null) {
                  result.openEndDrawer();
                }
              },
            ),
          ],
        ),
      ),
    );

    var pageFooter = Container(
      // decoration: const BoxDecoration(color: Colors.white24),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          // 转盘封面
          child: Obx(() {
            String? coverUrl =
                immersiveController.playingSong.value.album?.cover;
            return CircleCover(
              size: 180,
              coverUrl: coverUrl ?? "",
            );
          }),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Obx(() {
                  String songTitle =
                      immersiveController.playingSong.value.title;
                  String title = songTitle.isNotEmpty ? songTitle : "QQ音乐 听我想听";
                  return LayoutBuilder(builder: (c, s) {
                    final TextPainter textPainter = TextPainter(
                        text: TextSpan(
                          text: title,
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.ltr)
                      ..layout(minWidth: 0, maxWidth: double.infinity);

                    return SizedBox(
                      height: textPainter.height,
                      child: CarouselRichText(
                        titleColor: Colors.white,
                        titleSize: 15,
                        title: title,
                      ),
                    );
                  });
                }),
              ),
              const SizedBox(
                width: 15,
              ),
              Obx(() {
                Song playingSong = immersiveController.playingSong.value;
                List<Song> favSongs = profileController.favSongs;
                bool outline = !favSongs.hasSong(playingSong);
                return GestureDetector(
                  onTap: () {
                    if (outline) {
                      profileController.addFavSong(playingSong.songMid);
                    } else {
                      profileController.removeFavSong(playingSong.songMid);
                    }
                  },
                  child: Icon(
                    color: Colors.red,
                    outline
                        ? const IconData(0xe601, fontFamily: "IconFont")
                        : const IconData(0xe600, fontFamily: "IconFont"),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Obx(() {
            String author = immersiveController.playingSong.value.singer
                .map((i) => i.name)
                .join('/');
            return Text(
              author.isNotEmpty ? author : "未知歌手",
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Obx(() {
            var duration = immersiveController.duration;
            var current = immersiveController.current;
            var progress = immersiveController.progress;
            var disabled = ![
              ProcessingStateAdapter.ready,
              ProcessingStateAdapter.completed
            ].contains(immersiveController.status.value);
            var bufferedProgress = immersiveController.bufferedProgress;

            return ProgressSlider(
              height: 8,
              direction: Axis.horizontal,
              duration: duration.value,
              current: current.value,
              progress: progress.value,
              disabled: disabled,
              bufferedProgress: bufferedProgress.value,
              onSeeking: (progress) {
                immersiveController.seek(progress);
              },
            );
          }),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Container(
                  //   width: 200,
                  //   height: 200,
                  //   child: getWaveform(),
                  // ),
                  ShaderMask(
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
                    child: Obx(() {
                      String lyricText =
                          immersiveController.playingSongLyric.value;
                      Duration current = immersiveController.current.value;
                      return LyricsRenderer(
                        lyricText: lyricText,
                        current: current,
                      );
                    }),
                  ),
                ],
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
          // 高斯背景
          Transform.scale(
            scale: 1.5,
            child: Obx(() {
              var coverUrl =
                  immersiveController.playingSong.value.album?.cover ?? "";
              var backgroundImgUrl =
                  coverUrl.isNotEmpty ? coverUrl : 'images/bg_default.jpg';

              return backgroundImgUrl.contains("http")
                  ? Image.network(
                      backgroundImgUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(backgroundImgUrl, fit: BoxFit.cover);
            }),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 120,
                sigmaY: 120,
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

class _ImmersivePageWrapper extends StatelessWidget {
  final Animation? animation;

  const _ImmersivePageWrapper({this.animation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ImmersivePage(animation: animation),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        width: 520,
        child: SafeArea(
          child: DrawerPlaylist(),
        ), // Populate the Drawer in the last step.
      ),
    );
  }
}

class ImmersivePage extends Page {
  const ImmersivePage({super.key});

  @override
  Route createRoute(BuildContext context) {
    // PageRouteBuilder提供路由动画过渡效果
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        // 返回实际页面组件，传入 animation 对象，用于监听过渡动画结束
        return _ImmersivePageWrapper(
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

        // 平移动画
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
