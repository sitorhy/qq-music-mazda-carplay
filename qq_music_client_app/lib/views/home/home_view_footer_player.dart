import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class _PlayerItem extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double size;

  const _PlayerItem(
      {required this.icon,
      required this.width,
      required this.height,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: height - 4,
        width: width - 4,
        decoration: BoxDecoration(
          color: ClientColors.lightPrimary,
          shape: BoxShape.circle,
          border: Border.all(color: ClientColors.primary, width: 1.0),
        ),
        child: Icon(
          color: ClientColors.text,
          icon,
          size: size,
        ),
      ),
    );
  }
}

class HomeViewFooterPlayer extends StatelessWidget {
  final double height;
  final double? width;

  const HomeViewFooterPlayer({super.key, required this.height, this.width});

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
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey,
        //       offset: Offset.zero,
        //       blurRadius: 1.0,
        //       spreadRadius: 0.0)
        // ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PlayerItem(
            icon: const IconData(0xe63c, fontFamily: "IconFont"),
            width: height,
            height: height,
            size: 22,
          ),
          _PlayerItem(
            icon: const IconData(0xe65f, fontFamily: "IconFont"),
            width: height,
            height: height,
            size: 22,
          ),
          _PlayerItem(
            icon: const IconData(0xe610, fontFamily: "IconFont"),
            width: height,
            height: height,
            size: 18,
          ),
          _PlayerItem(
            icon: const IconData(0xe65e, fontFamily: "IconFont"),
            width: height,
            height: height,
            size: 22,
          ),
          _PlayerItem(
            icon: const IconData(0xe63e, fontFamily: "IconFont"),
            width: height,
            height: height,
            size: 22,
          ),
        ],
      ),
    );
  }
}
