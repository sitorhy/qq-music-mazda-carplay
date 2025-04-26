import 'package:qq_music_client_app/api/http_response.dart';
import 'package:qq_music_client_app/model/singer.dart';

class FetchFollowSingersRequest extends BaseApi<List<Singer>> {
  int pageNo;
  int pageSize;

  FetchFollowSingersRequest({
    this.pageNo = 1,
    this.pageSize = 30,
  });

  @override
  Map<String, dynamic> get body => {"pageNo": pageNo, "pageSize": pageSize};

  @override
  RequestMethod get method => RequestMethod.post;

  @override
  String get path => "follow/singers";

  @override
  List<Singer> fromJson(data) {
    return (data as Iterable).map((e) => Singer.fromJson(e)).toList();
  }
}