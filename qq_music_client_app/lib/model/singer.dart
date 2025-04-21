

import 'package:json_annotation/json_annotation.dart';

part 'singer.g.dart';

@JsonSerializable()
class Singer {
  final int singerId;
  final String singerMid;
  final String name;
  final String? description;
  final String? avatarUrl;

  Singer({
    required this.singerId,
    required this.singerMid,
    required this.name,
    this.description,
    this.avatarUrl,
  });

  factory Singer.fromJson(Map<String, dynamic> json) => _$SingerFromJson(json);

  Map<String, dynamic> toJson() => _$SingerToJson(this);
}
