import 'package:flutter/cupertino.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class HomeContentContainer extends StatelessWidget {
  final Widget child;

  const HomeContentContainer({super.key,  required this.child });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ClientColors.primary, ClientColors.primary],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: FractionallySizedBox(
        widthFactor: 1850 / 1945,
        heightFactor: 1.0,
        child: child
      ),
    );
  }
}