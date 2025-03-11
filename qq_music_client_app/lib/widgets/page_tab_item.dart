import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

enum PageTabItemState { normal, focused }

class PageTabItem extends StatelessWidget {
  final PageTabItemState state;
  final IconData? icon;
  final double width;
  final double height;
  final double iconSize;
  final GestureTapCallback? onTap;

  const PageTabItem(
      {super.key,
      this.state = PageTabItemState.normal,
      this.icon,
      this.height = 36,
      this.width = 64,
      this.iconSize = 24,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    var borderColor = state == PageTabItemState.focused
        ? ClientColors.primary
        : ClientColors.tabBorder;

    var iconChild = icon == null
        ? null
        : Icon(
            icon,
            size: iconSize,
            color: state == PageTabItemState.normal
                ? ClientColors.tabForeground
                : ClientColors.tabBackground,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
          ),
          color: state == PageTabItemState.focused
              ? ClientColors.primary
              : ClientColors.tabNormal,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: iconChild,
      ),
    );
  }
}
