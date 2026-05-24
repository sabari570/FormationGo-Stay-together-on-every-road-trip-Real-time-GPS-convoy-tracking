import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'device_profile_dao.g.dart';

@DriftAccessor(tables: [DeviceProfiles])
class DeviceProfileDao extends DatabaseAccessor<AppDatabase> with _$DeviceProfileDaoMixin {
  DeviceProfileDao(AppDatabase db) : super(db);

  Future<DeviceProfile?> getProfile(String id) =>
      (select(deviceProfiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> saveProfile(DeviceProfilesCompanion profile) =>
      into(deviceProfiles).insertOnConflictUpdate(profile);
}
