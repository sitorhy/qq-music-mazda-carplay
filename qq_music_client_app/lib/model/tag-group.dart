import 'package:json_annotation/json_annotation.dart';

part 'tag-group.g.dart';

@JsonSerializable()
class TagGroup {
  final int tagGroupId;
  final String tagGroupName;
  final String? icon;

  TagGroup({
    required this.tagGroupId,
    required this.tagGroupName,
    this.icon,
  });

  factory TagGroup.fromJson(Map<String, dynamic> json) => _$TagGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TagGroupToJson(this);
}
