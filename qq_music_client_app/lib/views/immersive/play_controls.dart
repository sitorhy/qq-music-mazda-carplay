import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class _ControlItem extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double size;
  final bool disabled;
  final bool loading;

  const _ControlItem({
    required this.icon,
    required this.width,
    required this.height,
    required this.size,
    this.disabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (loading) {
      child = const CircularProgressIndicator(
        color: ClientColors.textLight,
      );
    } else {
      child = Icon(
        color: disabled ? Colors.grey[700] : Colors.white70,
        icon,
        size: size,
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}

class PlayControls extends StatelessWidget {
  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  PlayControls({super.key});

  bool _btnDisabled() {
    return ![ProcessingStateAdapter.ready, ProcessingStateAdapter.completed]
        .contains(immersiveController.status.value);
  }

  @override
  Widget build(BuildContext context) {
    double width = 42;
    double height = 42;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              // 上一首
              if (_btnDisabled()) {
                return;
              }
              immersiveController.playPrev();
            },
            child: _ControlItem(
              icon: const IconData(0xe63c, fontFamily: "IconFont"),
              width: width,
              height: height,
              disabled: _btnDisabled(),
              size: 30,
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 快退
              immersiveController.fastBack();
            },
            child: Obx(() {
              return _ControlItem(
                icon: const IconData(0xe65f, fontFamily: "IconFont"),
                width: width,
                height: height,
                disabled: _btnDisabled(),
                size: 30,
              );
            }),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              // 播放 / 暂停
              if (![
                ProcessingStateAdapter.completed,
                ProcessingStateAdapter.ready,
              ].contains(immersiveController.status.value)) {
                return;
              }
              if (immersiveController.isPlaying.value) {
                immersiveController.pause();
              } else {
                immersiveController.play(null);
              }
            },
            child: Obx(() {
              bool isLoading = [
                ProcessingStateAdapter.loading,
              ].contains(immersiveController.status.value);
              bool canPlayClick = immersiveController.isPlaying.value &&
                  [
                    ProcessingStateAdapter.ready,
                  ].contains(immersiveController.status.value);
              var icon = !canPlayClick
                  ? const IconData(0xe635, fontFamily: "IconFont")
                  : const IconData(0xea8f, fontFamily: "IconFont");
              return _ControlItem(
                icon: icon,
                width: width,
                height: height,
                disabled: _btnDisabled(),
                loading: isLoading,
                size: 36,
              );
            }),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 快进
              immersiveController.fastForward();
            },
            child: Obx(() {
              return _ControlItem(
                icon: const IconData(0xe65e, fontFamily: "IconFont"),
                width: width,
                height: height,
                disabled: _btnDisabled(),
                size: 30,
              );
            }),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 下一首
              immersiveController.playNext();
            },
            child: Obx(() {
              return _ControlItem(
                icon: const IconData(0xe63e, fontFamily: "IconFont"),
                width: width,
                height: height,
                disabled: _btnDisabled(),
                size: 30,
              );
            }),
          ),
        ),
      ],
    );
  }
}
