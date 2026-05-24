// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceProfileEntityImpl _$$DeviceProfileEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceProfileEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarColor: json['avatarColor'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DeviceProfileEntityImplToJson(
        _$DeviceProfileEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarColor': instance.avatarColor,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
