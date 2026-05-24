import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';

part 'journey_details_provider.g.dart';

@riverpod
Stream<JourneyEntity?> watchJourneyDetails(WatchJourneyDetailsRef ref, String id) {
  return ref.watch(journeyRepositoryProvider).watchJourneys().map(
    (list) => list.cast<JourneyEntity?>().firstWhere(
          (j) => j?.id == id,
          orElse: () => null,
        ),
  );
}
