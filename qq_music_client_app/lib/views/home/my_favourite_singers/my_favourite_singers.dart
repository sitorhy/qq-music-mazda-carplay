import 'package:flutter/cupertino.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';

class MyFavouriteSingers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeContentContainer(
      child: Text("关注的歌手"),
    );
  }
}