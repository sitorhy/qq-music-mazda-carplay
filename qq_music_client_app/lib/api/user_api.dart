import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/song.dart';
import 'package:qq_music_client_app/model/user.dart';

class FetchUserProfileRequest extends BaseApi<User> {
  FetchUserProfileRequest();

  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "user/profile";

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}

class FetchUserFavSongsRequest extends BaseApi<List<Song>> {
  FetchUserFavSongsRequest();

  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "user/fav/songs";

  @override
  List<Song> fromJson(data) {
    return (data as Iterable).map((e) => Song.fromJson(e)).toList();
  }
}

class FetchUserFavSongsAddRequest extends BaseApi<bool> {
  final String songMid;

  FetchUserFavSongsAddRequest({required this.songMid});

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  Map<String, dynamic>? get body => {"songMid": songMid};

  @override
  String get path => "user/fav/songs/add";

  @override
  bool fromJson(data) {
    return data;
  }
}

class FetchUserFavSongsDelRequest extends BaseApi<bool> {
  final String songMid;

  FetchUserFavSongsDelRequest({required this.songMid});

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  Map<String, dynamic>? get body => {"songMid": songMid};

  @override
  String get path => "user/fav/songs/del";

  @override
  bool fromJson(data) {
    return data;
  }
}