// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag-group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagGroup _$TagGroupFromJson(Map<String, dynamic> json) => TagGroup(
      tagGroupId: (json['tagGroupId'] as num).toInt(),
      tagGroupName: json['tagGroupName'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$TagGroupToJson(TagGroup instance) => <String, dynamic>{
      'tagGroupId': instance.tagGroupId,
      'tagGroupName': instance.tagGroupName,
      'icon': instance.icon,
    };
