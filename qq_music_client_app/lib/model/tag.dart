import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'tag.g.dart';

const uuid = Uuid();

@JsonSerializable()
class Tag {
  final int tagId;
  final String tagName;

  final String uid = uuid.v4();

  Tag({
    required this.tagId,
    required this.tagName,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
