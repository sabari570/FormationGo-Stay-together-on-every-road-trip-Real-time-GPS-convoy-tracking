import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';

part 'join_journey_provider.g.dart';

@riverpod
class JoinJourney extends _$JoinJourney {
  @override
  AsyncValue<JourneyEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<JourneyEntity?> joinJourney(String pin) async {
    state = const AsyncValue.loading();
    try {
      // 1. Search Firestore for active journey with passcode
      JourneyEntity? foundJourney;
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('journeys')
            .where('passCode', isEqualTo: pin)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data();
          foundJourney = JourneyEntity(
            id: data['id'] as String,
            name: data['name'] as String,
            hostId: data['hostId'] as String,
            passCode: data['passCode'] as String,
            status: JourneyStatus.values.firstWhere(
              (e) => e.name == data['status'],
              orElse: () => JourneyStatus.active,
            ),
            createdAt: DateTime.parse(data['createdAt'] as String),
            updatedAt: DateTime.parse(data['updatedAt'] as String),
            sourceName: data['sourceName'] as String?,
            sourceLat: data['sourceLat'] as double?,
            sourceLng: data['sourceLng'] as double?,
            destinationName: data['destinationName'] as String?,
            destinationLat: data['destinationLat'] as double?,
            destinationLng: data['destinationLng'] as double?,
          );
        }
      } catch (e) {
        // Firestore query failed (e.g. Firebase not configured/initialized)
        // Fallback to local SQLite database search for demo/testing purposes
        final localJourneys = await ref.read(journeyRepositoryProvider).getAllJourneys();
        foundJourney = localJourneys.cast<JourneyEntity?>().firstWhere(
              (j) => j?.passCode == pin && j?.status == JourneyStatus.active,
              orElse: () => null,
            );
      }

      if (foundJourney != null) {
        // 2. Save found journey locally so that detail screen can query it
        await ref.read(journeyRepositoryProvider).saveJourney(foundJourney);
        state = AsyncValue.data(foundJourney);
        return foundJourney;
      } else {
        state = AsyncValue.error(
          Exception('No active journey found with passcode $pin'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    return null;
  }
}
