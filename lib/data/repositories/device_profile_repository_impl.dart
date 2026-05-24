import 'package:drift/drift.dart';
import '../../domain/entities/device_profile.dart';
import '../../domain/repositories/device_profile_repository.dart';
import '../database/daos/device_profile_dao.dart';
import '../database/app_database.dart';

class DeviceProfileRepositoryImpl implements DeviceProfileRepository {
  final DeviceProfileDao _dao;

  DeviceProfileRepositoryImpl(this._dao);

  @override
  Future<DeviceProfileEntity?> getProfile(String id) async {
    final profile = await _dao.getProfile(id);
    if (profile == null) return null;
    return DeviceProfileEntity(
      id: profile.id,
      name: profile.name,
      avatarColor: profile.avatarColor,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  @override
  Future<void> saveProfile(DeviceProfileEntity profile) async {
    await _dao.saveProfile(
      DeviceProfilesCompanion(
        id: Value(profile.id),
        name: Value(profile.name),
        avatarColor: Value(profile.avatarColor),
        createdAt: Value(profile.createdAt),
        updatedAt: Value(profile.updatedAt),
      ),
    );
  }
}
