import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/album.dart';
import 'package:qq_music_client_app/model/tag.dart';

class FetchNewestAlbumTagsRequest extends BaseApi<List<Tag>> {
  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "albums/newest/albums/tags";

  @override
  List<Tag> fromJson(data) {
    return (data as Iterable).map((e) => Tag.fromJson(e)).toList();
  }
}

class FetchNewestSongAlbumTagsRequest extends BaseApi<List<Tag>> {
  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "albums/newest/song/tags";

  @override
  List<Tag> fromJson(data) {
    return (data as Iterable).map((e) => Tag.fromJson(e)).toList();
  }
}

class FetchTopAlbumTagsRequest extends BaseApi<List<Tag>> {
  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "albums/top/tags";

  @override
  List<Tag> fromJson(data) {
    return (data as Iterable).map((e) => Tag.fromJson(e)).toList();
  }
}


class FetchAlbumsByTopTagRequest extends BaseApi<List<Album>> {
  final int tagId;

  FetchAlbumsByTopTagRequest({ required this.tagId });

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "albums/tag/top";

  @override
  List<Album> fromJson(data) {
    return (data as Iterable).map((e) => Album.fromJson(e)).toList();
  }
}

class FetchAlbumsBySongTagRequest extends BaseApi<List<Album>> {
  final int tagId;

  FetchAlbumsBySongTagRequest({ required this.tagId });

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "albums/tag/song";

  @override
  List<Album> fromJson(data) {
    return (data as Iterable).map((e) => Album.fromJson(e)).toList();
  }
}

class FetchAlbumsByAlbumTagRequest extends BaseApi<List<Album>> {
  final int tagId;

  FetchAlbumsByAlbumTagRequest({ required this.tagId });

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "albums/tag/album";

  @override
  List<Album> fromJson(data) {
    return (data as Iterable).map((e) => Album.fromJson(e)).toList();
  }
}