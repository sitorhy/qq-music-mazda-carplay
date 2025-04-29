import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_player.dart';
import 'package:qq_music_client_app/widgets/progress_slider.dart';
import 'package:qq_music_client_app/views/home/home_view_footer_song.dart';

class HomeViewFooter extends StatelessWidget {
  HomeViewFooter({super.key});

  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 35,
          child: HomeViewFooterSong(height: 38),
        ),
        const Expanded(
          flex: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(),
          ),
        ),
        Expanded(
          flex: 30,
          child: HomeViewFooterPlayer(height: 38),
        ),
        const Expanded(
          flex: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(),
          ),
        ),
        Expanded(
          flex: 33,
          child: Obx(() {
            var duration = immersiveController.duration;
            var current = immersiveController.current;
            var progress = immersiveController.progress;
            var isLoading = immersiveController.isLoading;
            var isSeeking = immersiveController.isSeeking;
            var seekingProgress = immersiveController.seekingProgress;
            var loadingProgress = immersiveController.loadingProgress;

            return ProgressSlider(
              duration: duration.value,
              current: current.value,
              progress: progress.value,
              isLoading: isLoading.value,
              isSeeking: isSeeking.value,
              seekingProgress: seekingProgress.value,
              loadingProgress: loadingProgress.value,
              onSeeking: (progress) {
                immersiveController.seek(progress);
              },
            );
          }),
        ),
      ],
    );
  }
}
