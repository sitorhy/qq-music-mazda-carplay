import 'package:flutter/material.dart';

class HomeViewFooterSongButton extends StatelessWidget {
  final IconData icon;
  final bool disabled;
  final Color color;

  const HomeViewFooterSongButton({
    super.key,
    required this.icon,
    this.disabled = true,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Icon(
        icon,
        size: 18,
        color: disabled ? Colors.grey : color,
      ),
    );
  }
}
