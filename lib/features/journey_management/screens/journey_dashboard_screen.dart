import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../domain/entities/journey.dart';
import '../../tracking/providers/location_provider.dart';
import '../../tracking/services/directions_service.dart';
import '../../home/providers/home_provider.dart';
import '../providers/journey_details_provider.dart';
import '../widgets/journey_setup_sheet.dart';
import '../widgets/invite_sheet.dart';

class JourneyDashboardScreen extends ConsumerStatefulWidget {
  final String journeyId;

  const JourneyDashboardScreen({super.key, required this.journeyId});

  @override
  ConsumerState<JourneyDashboardScreen> createState() =>
      _JourneyDashboardScreenState();
}

class _JourneyDashboardScreenState
    extends ConsumerState<JourneyDashboardScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
  bool _fetchingRoute = false;
  LatLng? _currentLatLng;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _fetchRoute(double startLat, double startLng, double destLat, double destLng) async {
    if (_fetchingRoute || _routePoints.isNotEmpty) return;

    setState(() {
      _fetchingRoute = true;
    });

    try {
      final points = await DirectionsService().getRouteCoordinates(
        startLat,
        startLng,
        destLat,
        destLng,
      );
      if (mounted) {
        setState(() {
          _routePoints = points;
        });
        _fitRouteBounds();
      }
    } catch (e) {
      // Quietly fail or show a light warning
    } finally {
      if (mounted) {
        setState(() {
          _fetchingRoute = false;
        });
      }
    }
  }

  void _fitRouteBounds() {
    if (_mapController == null || _routePoints.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;
    for (final point in _routePoints) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80.r),
      );
    }
  }

  void _recenter() {
    if (_mapController != null && _currentLatLng != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLatLng!, zoom: 15),
        ),
      );
    }
  }

  void _showInviteSheet(String name, String code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InviteSheet(journeyName: name, passCode: code),
    );
  }

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void _showMembersSheet() {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final name = profile?.name ?? 'Host';
    final avatarColor = profile?.avatarColor ?? '#4CAF50';
    final color = _fromHex(avatarColor);
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'H';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.bg0,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
          border: Border.all(color: AppColors.border, width: 1.w),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Convoy Members',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                '$name (You)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Active - Tracking GPS',
                style: TextStyle(color: Colors.greenAccent),
              ),
              trailing: const Icon(Icons.star, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }

  Set<Polyline> get _polylines {
    if (_routePoints.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints,
        color: AppColors.convoyBlue,
        width: 5.w.toInt(),
      ),
    };
  }

  Set<Marker> _buildMarkers(JourneyEntity journey) {
    final markers = <Marker>{};
    if (journey.sourceLat != null && journey.sourceLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: LatLng(journey.sourceLat!, journey.sourceLng!),
          infoWindow: InfoWindow(title: 'Starting point: ${journey.sourceName}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (journey.destinationLat != null && journey.destinationLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(journey.destinationLat!, journey.destinationLng!),
          infoWindow: InfoWindow(title: 'Destination: ${journey.destinationName}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationStreamProvider);
    final journeyAsync = ref.watch(watchJourneyDetailsProvider(widget.journeyId));
    final currentDeviceId = ref.watch(deviceIdProvider);

    return Scaffold(
      body: journeyAsync.when(
        data: (journey) {
          if (journey == null) {
            return const Center(
              child: Text('Journey not found', style: TextStyle(color: Colors.white)),
            );
          }

          final isHost = journey.hostId == currentDeviceId;
          final isRouteConfigured = journey.destinationLat != null;

          if (isRouteConfigured) {
            _fetchRoute(
              journey.sourceLat!,
              journey.sourceLng!,
              journey.destinationLat!,
              journey.destinationLng!,
            );
          }

          return Stack(
            children: [
              // 1. Google Map layer
              locationAsync.when(
                data: (position) {
                  final latLng = LatLng(position.latitude, position.longitude);
                  _currentLatLng = latLng;

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: isRouteConfigured
                          ? LatLng(journey.destinationLat!, journey.destinationLng!)
                          : latLng,
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapType: MapType.normal,
                    polylines: _polylines,
                    markers: _buildMarkers(journey),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (isRouteConfigured) {
                        _fitRouteBounds();
                      }
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.convoyBlue),
                ),
                error: (err, _) => Center(
                  child: Text('Location Error: $err', style: const TextStyle(color: Colors.white)),
                ),
              ),

              // 2. Custom header overlay
              Positioned(
                top: 50.h,
                left: 20.w,
                right: 20.w,
                child: _buildTopOverlay(journey, isRouteConfigured),
              ),

              // 3. Setup Sheet or Live overlay
              if (!isRouteConfigured)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: isHost
                      ? JourneySetupSheet(
                          journeyId: widget.journeyId,
                          onJourneyStarted: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Convoy route configured successfully!')),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.bg0,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                            border: Border.all(color: AppColors.border, width: 1.w),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(color: AppColors.convoyAmber),
                              SizedBox(height: 16.h),
                              Text(
                                'Waiting for Host...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'The host is setting up the destination.',
                                style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                )
              else
                Positioned(
                  bottom: 30.h,
                  left: 20.w,
                  right: 20.w,
                  child: _buildBottomOverlay(journey),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.convoyBlue),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTopOverlay(JourneyEntity journey, bool isRouteConfigured) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bg0.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  journey.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  isRouteConfigured ? 'Convoy Active • 1 member online' : 'Setting up Convoy...',
                  style: TextStyle(
                    color: isRouteConfigured ? AppColors.convoyGreen : AppColors.convoyAmber,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _showInviteSheet(journey.name, journey.passCode),
          )
        ],
      ),
    );
  }

  Widget _buildBottomOverlay(JourneyEntity journey) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.bg0.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomAction(Icons.people, 'Members', onTap: _showMembersSheet),
          _buildBottomAction(Icons.chat_bubble_outline, 'Chat', onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Convoy chat coming soon!')),
            );
          }),
          _buildBottomAction(Icons.qr_code, 'Invite', onTap: () => _showInviteSheet(journey.name, journey.passCode)),
          _buildBottomAction(Icons.my_location, 'Recenter', onTap: _recenter),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24.w),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: Colors.grey[400], fontSize: 10.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
