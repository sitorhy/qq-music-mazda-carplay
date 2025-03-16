import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class CircleImageSelectOption extends StatelessWidget {
  final double fontSize;
  final String imageUrl;
  final bool active;
  final String text;

  const CircleImageSelectOption(
      {super.key,
      this.fontSize = 15,
      this.active = false,
      required this.text,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: active
              ? ClientColors.activeSelectorBorder
              : ClientColors.selectorBorder,
        ),
        color: active ? ClientColors.background : ClientColors.lightPrimary,
        boxShadow: [
          BoxShadow(
              color: active
                  ? ClientColors.activeSelectorBorder
                  : ClientColors.selectorBorder,
              offset: Offset(0.0, 1.0), //阴影y轴偏移量
              blurRadius: 2, //阴影模糊程度
              spreadRadius: 0 //阴影扩散程度
              )
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 8.0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: active ? ClientColors.lightPrimary : ClientColors.subtitle,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
