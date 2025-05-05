import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/store/profile_controller.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';
import 'package:qq_music_client_app/widgets/title_divider.dart';

class Settings extends StatelessWidget {
  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");
  final ProfileController profileController =
      Get.find(tag: "profileController");

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeContentContainer(
      child: DefaultTextStyle(
        style: const TextStyle(
          decoration: TextDecoration.none,
          fontSize: 15,
          color: ClientColors.text,
        ),
        child: Obx(() {
          var profile = profileController.profile.value;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 23,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: profile.headpic,
                              placeholder: (context, url) => Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/avatar.webp"),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/avatar.webp"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Column(
                            children: [
                              Text(profile.nick),
                              Row(
                                children: (profile.iconlist ?? []).map((i) {
                                  return Image.network(
                                    i.srcUrl,
                                    height: 46 / 2,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(),
                ),
              ),
              Expanded(
                flex: 75,
                child: PositionedSingleScrollView(children: [
                  PositionedSingleScrollItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TitleDivider(
                          title: "设备信息",
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                          child: Table(
                            children: [
                              TableRow(
                                children: [Text("分辨率"), Text("1024 * 768")],
                              ),
                              TableRow(
                                children: [Text("DPI"), Text("800")],
                              ),
                              TableRow(
                                children: [Text("系统版本"), Text("Android 13")],
                              ),
                              TableRow(
                                children: [Text("RAM"), Text("2GB")],
                              ),
                              TableRow(
                                children: [Text("内置存储"), Text("2GB")],
                              ),
                              TableRow(
                                children: [Text("外置存储"), Text("2GB")],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PositionedSingleScrollItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TitleDivider(
                          title: "调试信息",
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                          child: Obx(() {
                            return Table(
                              children: [
                                TableRow(
                                  children: [
                                    const Text("音频状态"),
                                    Text(immersiveController.status.toString())
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("播放状态"),
                                    Text(immersiveController.isPlaying.string)
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        }),
      ),
    );
  }
}
