import 'package:json_annotation/json_annotation.dart';
import 'package:qq_music_client_app/utils/uuid.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  final int tagId;
  final String tagName;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String uid;

  Tag({
    required this.tagId,
    required this.tagName,
  }) {
    uid = generateModelRenderUuid(tagId.toString());
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
