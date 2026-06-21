import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/route_poi.dart';
import 'firestore_mapper.dart';

class FirestoreRoutePoiDatasource {
  final FirebaseFirestore _firestore;

  FirestoreRoutePoiDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _pois(String journeyId) =>
      _firestore.collection('journeys').doc(journeyId).collection('route_pois');

  Future<List<RoutePoiEntity>> getPois(String journeyId) async {
    final snapshot = await _pois(journeyId).get();
    return snapshot.docs.map(_fromMap).toList();
  }

  Stream<List<RoutePoiEntity>> watchPois(String journeyId) {
    return _pois(journeyId).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromMap).toList(),
        );
  }

  Future<bool> hasPois(String journeyId) async {
    final snapshot = await _pois(journeyId).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> savePois(List<RoutePoiEntity> pois) async {
    if (pois.isEmpty) return;
    final batch = _firestore.batch();
    for (final poi in pois) {
      final ref = _pois(poi.journeyId).doc(poi.id);
      batch.set(ref, {
        'id': poi.id,
        'journeyId': poi.journeyId,
        'name': poi.name,
        'category': poi.category,
        'tags': poi.tags,
        'latitude': poi.latitude,
        'longitude': poi.longitude,
        'rating': poi.rating,
        'address': poi.address,
        'source': poi.source,
        'fetchedAt': poi.fetchedAt.toIso8601String(),
      });
    }
    await batch.commit();
  }

  RoutePoiEntity _fromMap(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return RoutePoiEntity(
      id: data['id'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      name: data['name'] as String,
      category: data['category'] as String,
      tags: data['tags'] as String,
      latitude: FirestoreMapper.toDouble(data['latitude']) ?? 0,
      longitude: FirestoreMapper.toDouble(data['longitude']) ?? 0,
      rating: FirestoreMapper.toDouble(data['rating']),
      address: data['address'] as String?,
      source: data['source'] as String,
      fetchedAt: FirestoreMapper.fromTimestamp(data['fetchedAt']),
    );
  }
}
