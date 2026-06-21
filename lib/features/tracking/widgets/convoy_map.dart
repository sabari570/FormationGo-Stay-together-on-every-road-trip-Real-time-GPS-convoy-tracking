import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/map_constants.dart';

class ConvoyMapMarker {
  final String id;
  final LatLng position;
  final Color color;
  final Color? borderColor;
  final String title;
  final String? subtitle;
  final String? distanceLabel;
  final IconData icon;

  const ConvoyMapMarker({
    required this.id,
    required this.position,
    required this.color,
    this.borderColor,
    required this.title,
    this.subtitle,
    this.distanceLabel,
    this.icon = Icons.place,
  });
}

class ConvoyMap extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final List<LatLng> routePoints;
  final List<ConvoyMapMarker> markers;
  final LatLng? currentPosition;
  final LatLng? proximityCircleCenter;
  final double? proximityRadiusMeters;
  final void Function(LatLng point)? onLongPress;
  final void Function(MapController controller)? onMapCreated;

  const ConvoyMap({
    super.key,
    required this.initialCenter,
    this.initialZoom = 14,
    this.routePoints = const [],
    this.markers = const [],
    this.currentPosition,
    this.proximityCircleCenter,
    this.proximityRadiusMeters,
    this.onLongPress,
    this.onMapCreated,
  });

  @override
  State<ConvoyMap> createState() => _ConvoyMapState();
}

class _ConvoyMapState extends State<ConvoyMap> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allMarkers = <Marker>[
      ...widget.markers.map(_buildMarker),
      if (widget.currentPosition != null) _buildCurrentLocationMarker(),
    ];

    final showProximityCircle = widget.proximityCircleCenter != null &&
        widget.proximityRadiusMeters != null &&
        widget.proximityRadiusMeters! > 0;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        onLongPress: widget.onLongPress == null
            ? null
            : (_, point) => widget.onLongPress!(point),
        onMapReady: () => widget.onMapCreated?.call(_mapController),
      ),
      children: [
        TileLayer(
          urlTemplate: MapConstants.osmTileUrl,
          userAgentPackageName: MapConstants.androidPackageName,
        ),
        if (widget.routePoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.routePoints,
                color: AppColors.convoyBlue,
                strokeWidth: 5.w,
              ),
            ],
          ),
        if (showProximityCircle)
          CircleLayer(
            circles: [
              CircleMarker(
                point: widget.proximityCircleCenter!,
                radius: widget.proximityRadiusMeters!,
                useRadiusInMeter: true,
                color: AppColors.convoyGreen.withOpacity(0.15),
                borderColor: AppColors.convoyGreen.withOpacity(0.55),
                borderStrokeWidth: 2.w,
              ),
            ],
          ),
        MarkerLayer(markers: allMarkers),
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Marker _buildMarker(ConvoyMapMarker data) {
    final borderColor = data.borderColor ?? Colors.white;

    return Marker(
      point: data.position,
      width: 72.w,
      height: 72.h,
      child: GestureDetector(
        onTap: () {
          if (data.subtitle == null && data.distanceLabel == null) return;
          final lines = <String>[data.title];
          if (data.distanceLabel != null) {
            lines.add(data.distanceLabel!);
          } else if (data.subtitle != null) {
            lines.add(data.subtitle!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lines.join('\n')),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: data.color,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2.5.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(data.icon, color: Colors.white, size: 16.w),
            ),
            Transform.translate(
              offset: Offset(0, -4.h),
              child: Icon(Icons.arrow_drop_down, color: borderColor, size: 18.w),
            ),
            if (data.distanceLabel != null)
              Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  data.distanceLabel!,
                  style: TextStyle(
                    color: borderColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Marker _buildCurrentLocationMarker() {
    return Marker(
      point: widget.currentPosition!,
      width: 24.w,
      height: 24.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.convoyBlue.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.convoyBlue, width: 3.w),
        ),
      ),
    );
  }
}

/// Fits the map camera to show all [points] with optional [padding].
void fitMapToRoute(MapController controller, List<LatLng> points,
    {double padding = 80}) {
  if (points.isEmpty) return;

  final bounds = LatLngBounds.fromPoints(points);
  controller.fitCamera(
    CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.all(padding),
    ),
  );
}
