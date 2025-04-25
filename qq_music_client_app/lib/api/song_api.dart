import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/song.dart';

class FetchPlaylistSongsRequest extends BaseApi<List<Song>> {
  final int dissId;

  FetchPlaylistSongsRequest({required this.dissId});

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  Map<String, dynamic>? get body => {"dissId": dissId};

  @override
  String get path => "song/playlist";

  @override
  List<Song> fromJson(data) {
    return (data as Iterable).map((e) => Song.fromJson(e)).toList();
  }
}

class FetchAlbumSongsRequest extends BaseApi<List<Song>> {
  final String albumMid;
  final int albumId;
  final int pageNo;
  final int pageSize;

  FetchAlbumSongsRequest({
    required this.albumMid,
    this.albumId = 0,
    this.pageNo = 1,
    this.pageSize = 100,
  });

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  Map<String, dynamic>? get body => {
        "albumMid": albumMid,
        "pageNo": pageNo,
        "pageSize": pageSize,
        "albumId": albumId
      };

  @override
  String get path => "song/album";

  @override
  List<Song> fromJson(data) {
    return (data as Iterable).map((e) => Song.fromJson(e)).toList();
  }
}
