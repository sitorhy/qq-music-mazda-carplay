import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/device_info_controller.dart';
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
  final DeviceInfoController deviceInfoController =
      Get.find(tag: "deviceInfoController");

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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ClientColors.textLight),
                            color: ClientColors.lightPrimary,
                          ),
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                          child: Obx(() {
                            String platform =
                                deviceInfoController.platform.value;
                            String manufacturer =
                                deviceInfoController.manufacturer.value;
                            ResolutionRatio ratio =
                                deviceInfoController.resolutionRatio.value;

                            int memoryTotal =
                                deviceInfoController.memoryTotal.value;
                            int memoryAvail =
                                deviceInfoController.memoryAvail.value;

                            int storageTotal =
                                deviceInfoController.storageTotal.value;
                            int storageAvail =
                                deviceInfoController.storageAvail.value;

                            int extStorageTotal =
                                deviceInfoController.extStorageTotal.value;
                            int extStorageAvail =
                                deviceInfoController.extStorageAvail.value;
                            return Table(
                              children: [
                                TableRow(
                                  children: [
                                    const Text("制造商"),
                                    Text(manufacturer)
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("系统版本"),
                                    Text(platform)
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("分辨率"),
                                    Text("${ratio.width} * ${ratio.height}")
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("DPI"),
                                    Text("${ratio.dpi}")
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("RAM"),
                                    Text(
                                        "${(memoryAvail / 1024 / 1024 / 1024).toStringAsFixed(2)}GB / ${(memoryTotal / 1024 / 1024 / 1024).toStringAsFixed(2)}GB")
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("内置存储"),
                                    Text(
                                        "${(storageAvail / 1024 / 1024 / 1024).toStringAsFixed(2)}GB / ${(storageTotal / 1024 / 1024 / 1024).toStringAsFixed(2)}GB")
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("外置存储"),
                                    Text(
                                        "${(extStorageAvail / 1024 / 1024 / 1024).toStringAsFixed(2)}GB / ${(extStorageTotal / 1024 / 1024 / 1024).toStringAsFixed(2)}GB")
                                  ],
                                ),
                              ],
                            );
                          }),
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ClientColors.textLight),
                            color: ClientColors.lightPrimary,
                          ),
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                          child: Obx(() {
                            return Table(
                              children: [
                                TableRow(
                                  children: [
                                    const Text("音频状态"),
                                    Text(immersiveController.status.toString().split(".").last.toUpperCase())
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Text("播放状态"),
                                    Text(immersiveController.isPlaying.value ? "Yes" : "No")
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
