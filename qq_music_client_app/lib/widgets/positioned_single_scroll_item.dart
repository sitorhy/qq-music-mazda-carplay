import 'package:flutter/material.dart';

class PositionedSingleScrollItem extends StatelessWidget {
  final String tag;
  final Widget child;

  const PositionedSingleScrollItem(
      {super.key, required this.child, this.tag = ""});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
