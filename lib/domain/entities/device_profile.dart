import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_profile.freezed.dart';
part 'device_profile.g.dart';

@freezed
class DeviceProfileEntity with _$DeviceProfileEntity {
  const factory DeviceProfileEntity({
    required String id,
    required String name,
    required String avatarColor,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeviceProfileEntity;

  factory DeviceProfileEntity.fromJson(Map<String, dynamic> json) => _$DeviceProfileEntityFromJson(json);
}
