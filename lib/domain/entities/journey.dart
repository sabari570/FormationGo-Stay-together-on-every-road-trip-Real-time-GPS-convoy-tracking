import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

enum JourneyStatus { active, ended, paused }

@freezed
class JourneyEntity with _$JourneyEntity {
  const factory JourneyEntity({
    required String id,
    required String name,
    required String hostId,
    required String passCode,
    @Default(JourneyStatus.active) JourneyStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? sourceName,
    double? sourceLat,
    double? sourceLng,
    String? destinationName,
    double? destinationLat,
    double? destinationLng,
  }) = _JourneyEntity;

  factory JourneyEntity.fromJson(Map<String, dynamic> json) => _$JourneyEntityFromJson(json);
}
