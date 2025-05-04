import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq_music_client_app/store/immersive_controller.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class _PlayerItem extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double size;
  final bool disabled;
  final bool loading;

  const _PlayerItem({
    required this.icon,
    required this.width,
    required this.height,
    required this.size,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (loading) {
      child = const CircularProgressIndicator(
        color: ClientColors.textLight,
      );
    } else if (disabled) {
      child = Icon(
        color: Colors.grey,
        icon,
        size: size,
      );
    } else {
      child = Icon(
        color: ClientColors.text,
        icon,
        size: size,
      );
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      height: height - 4,
      width: width - 4,
      decoration: BoxDecoration(
        color: ClientColors.lightPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: ClientColors.primary, width: 1.0),
      ),
      child: child,
    );
  }
}

class HomeViewFooterPlayer extends StatelessWidget {
  final double height;
  final double? width;
  final ImmersiveController immersiveController =
      Get.find(tag: "immersiveController");

  HomeViewFooterPlayer({super.key, required this.height, this.width});

  bool _btnDisabled() {
    return ![ProcessingStateAdapter.ready, ProcessingStateAdapter.completed]
        .contains(immersiveController.status.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: ClientColors.lightPrimary,
        borderRadius: BorderRadius.all(
          Radius.circular(height / 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // 上一首
              if (_btnDisabled()) {
                return;
              }
            },
            child: Obx(() {
              return _PlayerItem(
                icon: const IconData(0xe63c, fontFamily: "IconFont"),
                width: height,
                height: height,
                disabled: _btnDisabled(),
                size: 22,
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 快退
              immersiveController.fastBack();
            },
            child: Obx(() {
              return _PlayerItem(
                icon: const IconData(0xe65f, fontFamily: "IconFont"),
                width: height,
                height: height,
                disabled: _btnDisabled(),
                size: 22,
              );
            }),
          ),
          GestureDetector(
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
                  ? const IconData(0xe610, fontFamily: "IconFont")
                  : const IconData(0xe693, fontFamily: "IconFont");
              return _PlayerItem(
                icon: icon,
                width: height,
                height: height,
                size: 18,
                loading: isLoading,
                disabled: _btnDisabled(),
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 快进
              immersiveController.fastForward();
            },
            child: Obx(() {
              return _PlayerItem(
                icon: const IconData(0xe65e, fontFamily: "IconFont"),
                width: height,
                height: height,
                disabled: _btnDisabled(),
                size: 22,
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              if (_btnDisabled()) {
                return;
              }
              // 下一首
            },
            child: Obx(() {
              return _PlayerItem(
                icon: const IconData(0xe63e, fontFamily: "IconFont"),
                width: height,
                height: height,
                disabled: _btnDisabled(),
                size: 22,
              );
            }),
          ),
        ],
      ),
    );
  }
}
