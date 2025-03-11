import 'package:flutter/cupertino.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class TitleDivider extends StatelessWidget {
  final String title;
  final double fontSize;

  const TitleDivider({super.key, this.title = "", this.fontSize = 15.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ClientColors.dividerColor,
      ),
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      child: Text(
        title,
        maxLines: 1,
        style: TextStyle(
          color: ClientColors.dividerTitleColor,
          decoration: TextDecoration.none,
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
