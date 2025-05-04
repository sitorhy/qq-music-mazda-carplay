import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';

class Settings extends StatelessWidget {
  final ImmersiveController immersiveController = Get.find(tag: "immersiveController");

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeContentContainer(
      child: Obx(() {
        return Column(
          children: [
            Text("状态：${immersiveController.status}"),
            Text("Playing：${immersiveController.isPlaying.value}")
          ],
        );
      }),
    );
  }
}