import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/device_profile.dart';
import '../../domain/repositories/device_profile_repository.dart';

class DeviceProfileRepositoryImpl implements DeviceProfileRepository {
  static const _profileKey = 'device_profile';

  final SharedPreferences _prefs;

  DeviceProfileRepositoryImpl(this._prefs);

  @override
  Future<DeviceProfileEntity?> getProfile(String id) async {
    final json = _prefs.getString(_profileKey);
    if (json == null) return null;

    final data = jsonDecode(json) as Map<String, dynamic>;
    if (data['id'] != id) return null;

    return DeviceProfileEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      avatarColor: data['avatarColor'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }

  @override
  Future<void> saveProfile(DeviceProfileEntity profile) async {
    await _prefs.setString(
      _profileKey,
      jsonEncode({
        'id': profile.id,
        'name': profile.name,
        'avatarColor': profile.avatarColor,
        'createdAt': profile.createdAt.toIso8601String(),
        'updatedAt': profile.updatedAt.toIso8601String(),
      }),
    );
  }
}
