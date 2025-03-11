import 'package:flutter/cupertino.dart';
import 'package:qq_music_client_app/views/home/home_content_container.dart';

class MyFavouritePlaylists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeContentContainer(
      child: Text("收藏的歌单"),
    );
  }
}