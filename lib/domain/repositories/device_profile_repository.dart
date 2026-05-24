import '../entities/device_profile.dart';

abstract class DeviceProfileRepository {
  Future<DeviceProfileEntity?> getProfile(String id);
  Future<void> saveProfile(DeviceProfileEntity profile);
}
