import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/journey.dart';

class FirestoreMapper {
  static DateTime fromTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static Timestamp toTimestamp(DateTime value) => Timestamp.fromDate(value);

  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static JourneyStatus parseJourneyStatus(String? value) {
    return JourneyStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => JourneyStatus.active,
    );
  }

  static Map<String, dynamic> journeyToMap(JourneyEntity journey) {
    return {
      'id': journey.id,
      'name': journey.name,
      'hostId': journey.hostId,
      'passCode': journey.passCode,
      'status': journey.status.name,
      'createdAt': journey.createdAt.toIso8601String(),
      'updatedAt': journey.updatedAt.toIso8601String(),
      'sourceName': journey.sourceName,
      'sourceLat': journey.sourceLat,
      'sourceLng': journey.sourceLng,
      'destinationName': journey.destinationName,
      'destinationLat': journey.destinationLat,
      'destinationLng': journey.destinationLng,
    };
  }

  static JourneyEntity journeyFromMap(Map<String, dynamic> data) {
    return JourneyEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      hostId: data['hostId'] as String,
      passCode: data['passCode'] as String,
      status: parseJourneyStatus(data['status'] as String?),
      createdAt: fromTimestamp(data['createdAt']),
      updatedAt: fromTimestamp(data['updatedAt']),
      sourceName: data['sourceName'] as String?,
      sourceLat: toDouble(data['sourceLat']),
      sourceLng: toDouble(data['sourceLng']),
      destinationName: data['destinationName'] as String?,
      destinationLat: toDouble(data['destinationLat']),
      destinationLng: toDouble(data['destinationLng']),
    );
  }
}
