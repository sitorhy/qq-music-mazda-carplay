import 'package:flutter/material.dart';

class HomeViewFooterSongButton extends StatelessWidget {
  final IconData icon;

  const HomeViewFooterSongButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}
