// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JourneyEntityImpl _$$JourneyEntityImplFromJson(Map<String, dynamic> json) =>
    _$JourneyEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      hostId: json['hostId'] as String,
      passCode: json['passCode'] as String,
      status: $enumDecodeNullable(_$JourneyStatusEnumMap, json['status']) ??
          JourneyStatus.active,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sourceName: json['sourceName'] as String?,
      sourceLat: (json['sourceLat'] as num?)?.toDouble(),
      sourceLng: (json['sourceLng'] as num?)?.toDouble(),
      destinationName: json['destinationName'] as String?,
      destinationLat: (json['destinationLat'] as num?)?.toDouble(),
      destinationLng: (json['destinationLng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$JourneyEntityImplToJson(_$JourneyEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hostId': instance.hostId,
      'passCode': instance.passCode,
      'status': _$JourneyStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'sourceName': instance.sourceName,
      'sourceLat': instance.sourceLat,
      'sourceLng': instance.sourceLng,
      'destinationName': instance.destinationName,
      'destinationLat': instance.destinationLat,
      'destinationLng': instance.destinationLng,
    };

const _$JourneyStatusEnumMap = {
  JourneyStatus.active: 'active',
  JourneyStatus.ended: 'ended',
  JourneyStatus.paused: 'paused',
};
