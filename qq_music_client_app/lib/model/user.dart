
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class IconListItem {
  final double width;
  final double height;
  final String srcUrl;

  IconListItem(this.width, this.height, this.srcUrl);

  factory IconListItem.fromJson(Map<String, dynamic> json) => _$IconListItemFromJson(json);

  Map<String, dynamic> toJson() => _$IconListItemToJson(this);
}

@JsonSerializable()
class Backpic {
  final String picurl;

  Backpic(this.picurl);

  factory Backpic.fromJson(Map<String, dynamic> json) => _$BackpicFromJson(json);

  Map<String, dynamic> toJson() => _$BackpicToJson(this);
}


@JsonSerializable()
class User {
  final String nick;
  final String headpic;
  final int uin;
  final List<IconListItem>? iconlist;
  final Backpic? backpic;

  User(this.nick, this.headpic, this.uin, this.iconlist, this.backpic);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}