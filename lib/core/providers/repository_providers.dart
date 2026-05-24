import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/device_profile_repository_impl.dart';
import '../../domain/repositories/device_profile_repository.dart';
import '../../data/repositories/journey_repository_impl.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../data/database/daos/device_profile_dao.dart';
import '../../data/database/daos/journey_dao.dart';
import 'database_provider.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
DeviceProfileRepository deviceProfileRepository(DeviceProfileRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return DeviceProfileRepositoryImpl(DeviceProfileDao(db));
}

@Riverpod(keepAlive: true)
JourneyRepository journeyRepository(JourneyRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return JourneyRepositoryImpl(JourneyDao(db));
}
