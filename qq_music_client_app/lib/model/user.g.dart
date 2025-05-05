// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IconListItem _$IconListItemFromJson(Map<String, dynamic> json) => IconListItem(
      (json['width'] as num).toDouble(),
      (json['height'] as num).toDouble(),
      json['srcUrl'] as String,
    );

Map<String, dynamic> _$IconListItemToJson(IconListItem instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'srcUrl': instance.srcUrl,
    };

Backpic _$BackpicFromJson(Map<String, dynamic> json) => Backpic(
      json['picurl'] as String,
    );

Map<String, dynamic> _$BackpicToJson(Backpic instance) => <String, dynamic>{
      'picurl': instance.picurl,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['nick'] as String,
      json['headpic'] as String,
      (json['uin'] as num).toInt(),
      (json['iconlist'] as List<dynamic>?)
          ?.map((e) => IconListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['backpic'] == null
          ? null
          : Backpic.fromJson(json['backpic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nick': instance.nick,
      'headpic': instance.headpic,
      'uin': instance.uin,
      'iconlist': instance.iconlist,
      'backpic': instance.backpic,
    };
