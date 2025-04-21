import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/playlist.dart';
import 'package:qq_music_client_app/model/tag-group.dart';
import 'package:qq_music_client_app/model/tag.dart';

class FetchAllTagGroupsRequest extends BaseApi<List<TagGroup>> {
  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "category/all";

  @override
  List<TagGroup> fromJson(data) {
    return (data as Iterable).map((e) => TagGroup.fromJson(e)).toList();
  }
}

class FetchTagsRequest extends BaseApi<List<Tag>> {
  int tagGroupId;

  FetchTagsRequest({required this.tagGroupId});

  @override
  Map<String, dynamic> get body => {"tagGroupId": tagGroupId};

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "category/tags";

  @override
  List<Tag> fromJson(data) {
    return (data as Iterable).map((e) => Tag.fromJson(e)).toList();
  }
}

class FetchRecommendedTagsRequest extends BaseApi<List<Tag>> {
  int pageNo;
  int pageSize;

  FetchRecommendedTagsRequest({
    this.pageNo = 1,
    this.pageSize = 30,
  });

  @override
  Map<String, dynamic> get body => {"pageNo": pageNo, "pageSize": pageSize};

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "category/recommended";

  @override
  List<Tag> fromJson(data) {
    return (data as Iterable).map((e) => Tag.fromJson(e)).toList();
  }
}

class FetchTagPlaylistsRequest extends BaseApi<List<Playlist>> {
  int pageNo;
  int pageSize;
  int categoryId;

  FetchTagPlaylistsRequest({
    this.pageNo = 1,
    this.pageSize = 30,
    required this.categoryId,
  });

  @override
  Map<String, dynamic> get body => {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "categoryId": categoryId,
      };

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "category/playlist";

  @override
  List<Playlist> fromJson(data) {
    return (data as Iterable).map((e) => Playlist.fromJson(e)).toList();
  }
}