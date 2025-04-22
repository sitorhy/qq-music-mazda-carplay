import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/song.dart';

class FetchPlaylistSongsRequest extends BaseApi<List<Song>> {
  final int dissId;

  FetchPlaylistSongsRequest({required this.dissId});

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  Map<String, dynamic>? get body => { "dissId": dissId };

  @override
  String get path => "song/playlist";

  @override
  List<Song> fromJson(data) {
    return (data as Iterable).map((e) => Song.fromJson(e)).toList();
  }
}