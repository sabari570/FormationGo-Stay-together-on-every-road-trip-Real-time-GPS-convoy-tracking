import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/firestore/firestore_chat_datasource.dart';
import '../../data/datasources/firestore/firestore_checkpoint_datasource.dart';
import '../../data/datasources/firestore/firestore_group_chat_datasource.dart';
import '../../data/datasources/firestore/firestore_device_journey_datasource.dart';
import '../../data/datasources/firestore/firestore_join_code_datasource.dart';
import '../../data/datasources/firestore/firestore_journey_datasource.dart';
import '../../data/datasources/firestore/firestore_location_datasource.dart';
import '../../data/datasources/firestore/firestore_member_auth_datasource.dart';
import '../../data/datasources/firestore/firestore_member_datasource.dart';
import '../../data/datasources/firestore/firestore_route_poi_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/device_profile_repository_impl.dart';
import '../../data/repositories/group_chat_repository_impl.dart';
import '../../data/repositories/journey_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/member_repository_impl.dart';
import '../../data/repositories/route_poi_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/device_profile_repository.dart';
import '../../domain/repositories/group_chat_repository.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/member_repository.dart';
import '../../domain/repositories/route_poi_repository.dart';
import '../services/message_encryption_service.dart';
import 'device_identity_provider.dart';
import 'firebase_provider.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
DeviceProfileRepository deviceProfileRepository(
    DeviceProfileRepositoryRef ref) {
  return DeviceProfileRepositoryImpl(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
JourneyRepository journeyRepository(JourneyRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  final joinCodeDs = FirestoreJoinCodeDatasource(firestore);
  final deviceJourneyDs = FirestoreDeviceJourneyDatasource(firestore);
  return JourneyRepositoryImpl(
    FirestoreJourneyDatasource(firestore, joinCodeDs, deviceJourneyDs),
    FirestoreCheckpointDatasource(firestore),
  );
}

@Riverpod(keepAlive: true)
MemberRepository memberRepository(MemberRepositoryRef ref) {
  return MemberRepositoryImpl(
    FirestoreMemberDatasource(ref.watch(firestoreProvider)),
  );
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(LocationRepositoryRef ref) {
  return LocationRepositoryImpl(
    FirestoreLocationDatasource(ref.watch(firestoreProvider)),
  );
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepositoryImpl(
    FirestoreChatDatasource(ref.watch(firestoreProvider)),
  );
}

@Riverpod(keepAlive: true)
RoutePoiRepository routePoiRepository(RoutePoiRepositoryRef ref) {
  return RoutePoiRepositoryImpl(
    FirestoreRoutePoiDatasource(ref.watch(firestoreProvider)),
  );
}

@Riverpod(keepAlive: true)
MessageEncryptionService messageEncryptionService(
    MessageEncryptionServiceRef ref) {
  return MessageEncryptionService();
}

@Riverpod(keepAlive: true)
FirestoreMemberAuthDatasource memberAuthDatasource(
    MemberAuthDatasourceRef ref) {
  return FirestoreMemberAuthDatasource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
GroupChatRepository groupChatRepository(GroupChatRepositoryRef ref) {
  return GroupChatRepositoryImpl(
    FirestoreGroupChatDatasource(ref.watch(firestoreProvider)),
    ref.watch(messageEncryptionServiceProvider),
  );
}
