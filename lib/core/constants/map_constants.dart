/// Free map/routing endpoints (OpenStreetMap + OSRM).
class MapConstants {
  static const osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const osrmBaseUrl = 'https://router.project-osrm.org';
  static const overpassUrl = 'https://overpass-api.de/api/interpreter';
  static const overpassFallbackUrl =
      'https://overpass.kumi.systems/api/interpreter';
  static const nominatimUserAgent = 'FormationGo/1.0 (convoy-tracking-app)';
  static const overpassUserAgent =
      'FormationGo/1.0 (convoy-tracking-app; +https://openstreetmap.org)';
  static const androidPackageName = 'com.example.formation_go';
}
