import 'package:qq_music_client_app/api/http_response.dart';

class TagGroup {
  int? tagGroupId;
  String? tagGroupName;
  String? icon;

  TagGroup({this.tagGroupId, this.tagGroupName, this.icon});

  TagGroup.fromJson(Map<String, dynamic> json) {
    tagGroupId = json['tagGroupId'];
    tagGroupName = json['tagGroupName'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tagGroupId'] = tagGroupId;
    data['tagGroupName'] = tagGroupName;
    data['icon'] = icon;
    return data;
  }
}

class Tag {
  int? tagId;
  String? tagName;

  Tag({this.tagId, this.tagName});

  Tag.fromJson(Map<String, dynamic> json) {
    tagId = json['tagId'];
    tagName = json['tagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tagId'] = tagId;
    data['tagName'] = tagName;
    return data;
  }
}


class FetchAllTagGroupsRequest extends BaseApi<HttpResponse<List<TagGroup>>> {
  @override
  RequestMethod get method => RequestMethod.get;

  @override
  String get path => "category/all";

  @override
  fromJson(Map<String, dynamic> json) {
    return HttpResponse.fromJson(json, List<TagGroup>.from(
        (json["data"] as Iterable).map((e) => TagGroup.fromJson(e))
    ));
  }
}