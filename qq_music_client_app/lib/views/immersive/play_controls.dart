
import 'package:flutter/material.dart';

class _ControlItem extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double size;

  const _ControlItem(
      {required this.icon,
        required this.width,
        required this.height,
        required this.size});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        // decoration: BoxDecoration(color: Colors.white24),
        height: height,
        width: width,
        child: Icon(
          color: Colors.white70,
          icon,
          size: size,
        ),
      ),
    );
  }
}

class PlayControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = 42;
    double height = 42;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // _ControlItem(
        //   icon: const IconData(0xe601, fontFamily: "IconFont"),
        //   width: width,
        //   height: height,
        //   size: 22,
        // ),
        _ControlItem(
          icon: const IconData(0xe63c, fontFamily: "IconFont"),
          width: width,
          height: height,
          size: 30,
        ),
        _ControlItem(
          icon: const IconData(0xe65f, fontFamily: "IconFont"),
          width: width,
          height: height,
          size: 30,
        ),
        _ControlItem(
          icon: const IconData(0xe635, fontFamily: "IconFont"),
          width: width,
          height: height,
          size: 36,
        ),
        _ControlItem(
          icon: const IconData(0xe65e, fontFamily: "IconFont"),
          width: width,
          height: height,
          size: 30,
        ),
        _ControlItem(
          icon: const IconData(0xe63e, fontFamily: "IconFont"),
          width: width,
          height: height,
          size: 30,
        ),
      ],
    );
  }
}