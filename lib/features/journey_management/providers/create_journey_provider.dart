import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';

part 'create_journey_provider.g.dart';

@riverpod
class CreateJourney extends _$CreateJourney {
  @override
  AsyncValue<JourneyEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createJourney(String name) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(journeyRepositoryProvider);
      final hostId = ref.read(deviceIdProvider);
      
      final random = Random();
      final passcode = (100000 + random.nextInt(900000)).toString();
      
      final journey = JourneyEntity(
        id: const Uuid().v4(),
        name: name,
        hostId: hostId,
        passCode: passcode,
        status: JourneyStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.saveJourney(journey);
      
      state = AsyncValue.data(journey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
