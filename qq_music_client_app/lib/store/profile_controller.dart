import 'package:get/get.dart';
import 'package:qq_music_client_app/api/user_api.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/model/user.dart';
import 'package:qq_music_client_app/utils/toast.dart';

class ProfileController extends GetxController {
  RxList<Song> favSongs = RxList([]);
  Rx<User> profile = User("", "", 0, [], Backpic("")).obs;


  @override
  void onInit() async {
    super.onInit();
    await getProfileDetail();
    await loadFavSongs();
  }

  getProfileDetail() async {
    try {
      var response = await FetchUserProfileRequest().request();
      if (response.data != null) {
        profile.value = response.data!;
      }
    } catch (e) {
      toastError(e);
    }
  }

  loadFavSongs() async {
    try {
      var response = await FetchUserFavSongsRequest().request();
      favSongs.value = response.data ?? [];
    } catch (e) {
      toastError(e);
    }
  }

  addFavSong(String songMid) async {
    try {
      var response =
          await FetchUserFavSongsAddRequest(songMid: songMid).request();
      if (response.data != null) {
        await loadFavSongs();
      }
    } catch (e) {
      toastError(e);
    }
  }

  removeFavSong(String songMid) async {
    try {
      var response =
          await FetchUserFavSongsDelRequest(songMid: songMid).request();
      if (response.data != null) {
        await loadFavSongs();
      }
    } catch (e) {
      toastError(e);
    }
  }
}
