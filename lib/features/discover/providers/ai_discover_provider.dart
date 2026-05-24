import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/ai_discover_service.dart';
import '../../../core/providers/network_provider.dart';

part 'ai_discover_provider.g.dart';

@riverpod
AiDiscoverService aiDiscoverService(AiDiscoverServiceRef ref) {
  return AiDiscoverService(ref.watch(dioProvider));
}
