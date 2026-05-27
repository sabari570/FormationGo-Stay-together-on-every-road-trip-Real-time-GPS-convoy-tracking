import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/checkpoint.dart';
import '../../tracking/providers/location_provider.dart';
import '../../tracking/services/directions_service.dart';
import '../../home/providers/home_provider.dart';
import '../providers/journey_details_provider.dart';
import '../providers/place_search_provider.dart';
import '../widgets/journey_setup_sheet.dart';
import '../widgets/invite_sheet.dart';
import '../widgets/place_search_sheet.dart';
import 'package:geolocator/geolocator.dart';

// ---------------------------------------------------------------------------
// DummyMember — simulates a convoy member for development/demo purposes.
// ---------------------------------------------------------------------------
class DummyMember {
  final String id;
  final String name;
  final String avatarInitial;
  final Color avatarColor;
  final double markerHue;
  int currentRouteIndex;
  LatLng currentPosition;

  DummyMember({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.avatarColor,
    required this.markerHue,
    required this.currentRouteIndex,
    required this.currentPosition,
  });
}

class JourneyDashboardScreen extends ConsumerStatefulWidget {
  final String journeyId;

  const JourneyDashboardScreen({super.key, required this.journeyId});

  @override
  ConsumerState<JourneyDashboardScreen> createState() =>
      _JourneyDashboardScreenState();
}

class _JourneyDashboardScreenState extends ConsumerState<JourneyDashboardScreen>
    with WidgetsBindingObserver {
  // ----------------------------------------------------------------
  // DEV FLAG: set to false to disable dummy simulation in production.
  // ----------------------------------------------------------------
  static const bool _useDummyRealtimeData = true;

  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
  bool _fetchingRoute = false;
  LatLng? _currentLatLng;

  // Dummy member simulation state
  final List<DummyMember> _dummyMembers = [];
  Timer? _dummyMovementTimer;
  bool _dummyInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dummyMovementTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the user returns from the device Settings page, re-check location.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(locationStreamProvider);
    }
  }

  // ---------------------------------------------------------------------------
  // Dummy member helpers (only active when _useDummyRealtimeData == true)
  // ---------------------------------------------------------------------------

  /// Seeds dummy members at staggered positions along the fetched route.
  void _initializeDummyMembers() {
    if (!_useDummyRealtimeData || _dummyInitialized || _routePoints.length < 6)
      return;
    _dummyInitialized = true;

    final routeLen = _routePoints.length;
    // Stagger: member 1 starts at ~15% of route, member 2 at ~8%, member 3 at ~2%
    final offsets = [
      max(0, (routeLen * 0.15).round()),
      max(0, (routeLen * 0.08).round()),
      max(0, (routeLen * 0.02).round())
    ];

    final specs = [
      {
        'id': 'dummy_alex',
        'name': 'Alex Mercer',
        'initial': 'A',
        'color': AppColors.convoyBlue,
        'hue': BitmapDescriptor.hueAzure,
      },
      {
        'id': 'dummy_sarah',
        'name': 'Sarah Connor',
        'initial': 'S',
        'color': AppColors.convoyAmber,
        'hue': BitmapDescriptor.hueOrange,
      },
      {
        'id': 'dummy_raj',
        'name': 'Raj Patel',
        'initial': 'R',
        'color': Colors.deepPurple,
        'hue': BitmapDescriptor.hueViolet,
      },
    ];

    for (var i = 0; i < specs.length; i++) {
      final startIdx = offsets[i];
      _dummyMembers.add(DummyMember(
        id: specs[i]['id'] as String,
        name: specs[i]['name'] as String,
        avatarInitial: specs[i]['initial'] as String,
        avatarColor: specs[i]['color'] as Color,
        markerHue: specs[i]['hue'] as double,
        currentRouteIndex: startIdx,
        currentPosition: _routePoints[startIdx],
      ));
    }

    _startDummyMovement();
  }

  /// Advances all dummy members along the route every 2 seconds.
  void _startDummyMovement() {
    _dummyMovementTimer?.cancel();
    _dummyMovementTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        for (final member in _dummyMembers) {
          // Advance 1-2 route points per tick to simulate varying speed
          final step = 1 + Random().nextInt(2);
          final nextIdx =
              min(member.currentRouteIndex + step, _routePoints.length - 1);
          member.currentRouteIndex = nextIdx;
          member.currentPosition = _routePoints[nextIdx];
        }
      });
    });
  }

  /// Returns approximate km remaining for a dummy member based on route index.
  String _memberDistanceLabel(DummyMember member) {
    final hostIdx = _routePoints.length - 1; // host is at end (destination)
    final diff = hostIdx - member.currentRouteIndex;
    if (diff <= 0) return 'Arrived at Destination';
    // Each route point is roughly 20-50m; estimate ~30m per point
    final estimatedMeters = diff * 30;
    if (estimatedMeters >= 1000) {
      return '${(estimatedMeters / 1000).toStringAsFixed(1)} km behind';
    }
    return '${estimatedMeters}m behind';
  }

  Color _memberStatusColor(DummyMember member) {
    final diff = (_routePoints.length - 1) - member.currentRouteIndex;
    if (diff <= 0) return Colors.greenAccent;
    if (diff * 30 > 3000) return AppColors.convoyAmber;
    return Colors.greenAccent;
  }

  void _fetchRoute(
      double startLat, double startLng, double destLat, double destLng) async {
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
        // Seed dummy members once route is available
        _initializeDummyMembers();
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

  Future<void> _confirmCancelOrLeaveJourney(
      JourneyEntity journey, bool isHost) async {
    final title = isHost ? 'Cancel Journey' : 'Leave Journey';
    final message = isHost
        ? 'Are you sure you want to cancel this journey in mid? This will end the convoy for everyone.'
        : 'Are you sure you want to leave this convoy journey?';
    final actionText = isHost ? 'Cancel Journey' : 'Leave';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.bg1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: AppColors.border),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No',
                style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.convoyRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                actionText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (isHost) {
        final updated = journey.copyWith(
          status: JourneyStatus.ended,
          updatedAt: DateTime.now(),
        );
        await ref.read(journeyRepositoryProvider).saveJourney(updated);
      }
      if (mounted) {
        context.go('/');
      }
    }
  }

  Future<void> _showAddCheckpointDialog(LatLng latLng,
      {String? defaultName}) async {
    final nameController = TextEditingController(text: defaultName ?? '');
    String selectedType = 'meetup';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.bg1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: const BorderSide(color: AppColors.border),
              ),
              title: Text(
                'Add Checkpoint',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      labelText: 'Checkpoint Name',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      hintText: 'e.g. Starbucks, Gas Station, Rest Area',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: AppColors.bg2,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            const BorderSide(color: AppColors.convoyBlue),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Select Type',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTypeBtn(
                        label: 'Meetup',
                        type: 'meetup',
                        icon: Icons.people,
                        color: AppColors.convoyBlue,
                        isSelected: selectedType == 'meetup',
                        onTap: () =>
                            setDialogState(() => selectedType = 'meetup'),
                      ),
                      _buildTypeBtn(
                        label: 'Fuel',
                        type: 'fuel',
                        icon: Icons.local_gas_station,
                        color: AppColors.convoyAmber,
                        isSelected: selectedType == 'fuel',
                        onTap: () =>
                            setDialogState(() => selectedType = 'fuel'),
                      ),
                      _buildTypeBtn(
                        label: 'Rest',
                        type: 'rest',
                        icon: Icons.restaurant,
                        color: AppColors.convoyGreen,
                        isSelected: selectedType == 'rest',
                        onTap: () =>
                            setDialogState(() => selectedType = 'rest'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.convoyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please enter a name for the checkpoint')),
                      );
                      return;
                    }
                    Navigator.of(context).pop();

                    final cp = CheckpointEntity(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      journeyId: widget.journeyId,
                      name: name,
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                      radius: 100,
                      type: selectedType,
                    );

                    final messenger = ScaffoldMessenger.of(context);
                    await ref
                        .read(journeyRepositoryProvider)
                        .saveCheckpoint(cp);
                    messenger.showSnackBar(
                      SnackBar(
                          content:
                              Text('Checkpoint "$name" added successfully!')),
                    );
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTypeBtn({
    required String label,
    required String type,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppColors.bg2,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? color : Colors.grey[400], size: 20.w),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckpointsSheet(JourneyEntity journey) {
    final currentDeviceId = ref.read(deviceIdProvider);
    final isHost = journey.hostId == currentDeviceId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 0.65.sh,
          decoration: BoxDecoration(
            color: AppColors.bg0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.r),
              topRight: Radius.circular(28.r),
            ),
            border: Border.all(color: AppColors.border, width: 1.w),
          ),
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
          child: StreamBuilder<List<CheckpointEntity>>(
            stream: ref
                .watch(journeyRepositoryProvider)
                .watchCheckpoints(journey.id),
            builder: (context, snapshot) {
              final checkpoints = snapshot.data ?? [];

              return Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checkpoints',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                      if (isHost)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.convoyBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                          ),
                          icon:
                              Icon(Icons.add, color: Colors.white, size: 16.w),
                          label: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () =>
                              _handleAddNewCheckpoint(context, journey.id),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (isHost) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Convoy Status:',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 13.sp),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                journey.status == JourneyStatus.paused
                                    ? AppColors.convoyGreen
                                    : AppColors.convoyAmber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 6.h),
                          ),
                          icon: Icon(
                            journey.status == JourneyStatus.paused
                                ? Icons.play_arrow
                                : Icons.pause,
                            color: Colors.white,
                            size: 16.w,
                          ),
                          label: Text(
                            journey.status == JourneyStatus.paused
                                ? 'Resume Convoy'
                                : 'Pause Convoy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            final newStatus =
                                journey.status == JourneyStatus.paused
                                    ? JourneyStatus.active
                                    : JourneyStatus.paused;
                            final updated = journey.copyWith(
                              status: newStatus,
                              updatedAt: DateTime.now(),
                            );
                            await ref
                                .read(journeyRepositoryProvider)
                                .saveJourney(updated);
                          },
                        ),
                      ],
                    ),
                    Divider(color: AppColors.border, height: 20.h),
                  ],
                  SizedBox(height: 8.h),
                  Expanded(
                    child: checkpoints.isEmpty
                        ? Center(
                            child: Text(
                              'No checkpoints added yet.',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 14.sp),
                            ),
                          )
                        : ListView.builder(
                            itemCount: checkpoints.length,
                            itemBuilder: (context, index) {
                              final cp = checkpoints[index];
                              IconData typeIcon;
                              Color typeColor;
                              switch (cp.type) {
                                case 'fuel':
                                  typeIcon = Icons.local_gas_station;
                                  typeColor = AppColors.convoyAmber;
                                  break;
                                case 'rest':
                                  typeIcon = Icons.restaurant;
                                  typeColor = AppColors.convoyGreen;
                                  break;
                                default:
                                  typeIcon = Icons.people;
                                  typeColor = AppColors.convoyBlue;
                              }

                              return Card(
                                color: AppColors.bg1,
                                margin: EdgeInsets.only(bottom: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: journey.status ==
                                                JourneyStatus.paused &&
                                            index == 0
                                        ? AppColors.convoyAmber.withOpacity(0.5)
                                        : AppColors.border,
                                    width: 1.w,
                                  ),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: typeColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(typeIcon,
                                        color: typeColor, size: 20.w),
                                  ),
                                  title: Text(
                                    cp.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Type: ${cp.type.toUpperCase()} • Radius: ${cp.radius.round()}m',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 11.sp),
                                  ),
                                  trailing: isHost
                                      ? IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.redAccent),
                                          onPressed: () async {
                                            await ref
                                                .read(journeyRepositoryProvider)
                                                .deleteCheckpoint(cp.id);
                                          },
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _handleAddNewCheckpoint(BuildContext sheetCtx, String journeyId) {
    Navigator.of(sheetCtx).pop();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bg1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            border: Border.all(color: AppColors.border, width: 1.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Checkpoint',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading:
                    Icon(Icons.search, color: AppColors.convoyBlue, size: 22.w),
                title: const Text('Search for Location',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final result = await showModalBottomSheet<PlaceDetails>(
                    context: this.context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const PlaceSearchSheet(
                        title: 'Search Checkpoint Location'),
                  );

                  if (result != null) {
                    _showAddCheckpointDialog(
                        LatLng(result.latitude, result.longitude),
                        defaultName: result.name);
                  }
                },
              ),
              Divider(color: AppColors.border, height: 1.h),
              ListTile(
                leading: Icon(Icons.touch_app,
                    color: AppColors.convoyGreen, size: 22.w),
                title: const Text('Long-press on Map',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Long-press anywhere on the map to add a checkpoint at that location!'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // ---------------------------------------------------------------------------
  // Location error overlay — shown instead of the map when location is
  // unavailable.  Detects whether the service is off or permission is missing
  // and opens the right settings page.  The WidgetsBindingObserver above
  // automatically retries the provider when the app comes back to foreground.
  // ---------------------------------------------------------------------------
  Widget _buildLocationErrorOverlay(Object error, JourneyEntity? journey) {
    final msg = error.toString();
    final isServiceDisabled = msg.contains('services are disabled');
    final isPermanentlyDenied = msg.contains('permanently denied');

    final fallbackLat = journey?.sourceLat ?? 20.5937;
    final fallbackLng = journey?.sourceLng ?? 78.9629;

    return Stack(
      children: [
        // Faded map as background so the screen doesn't look empty.
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(fallbackLat, fallbackLng),
            zoom: 6,
          ),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
        ),
        // Dark scrim
        Container(color: Colors.black.withOpacity(0.65)),
        // Centered error card
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 28.w),
            padding: EdgeInsets.fromLTRB(28.w, 32.h, 28.w, 28.h),
            decoration: BoxDecoration(
              color: AppColors.bg1,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: AppColors.border, width: 1.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon badge
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AppColors.convoyAmber.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isServiceDisabled
                        ? Icons.location_off_rounded
                        : Icons.location_disabled_rounded,
                    color: AppColors.convoyAmber,
                    size: 40.w,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  isServiceDisabled
                      ? 'Location Services Off'
                      : 'Location Permission Needed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  isServiceDisabled
                      ? 'FormationGo needs your GPS to track convoy members in real time. Please turn on Location Services and come back.'
                      : isPermanentlyDenied
                          ? 'Location permission is permanently denied. Open App Settings to enable it and then return to the app.'
                          : 'FormationGo needs location access to show your position in the convoy.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13.sp,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.h),
                // Primary action button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isServiceDisabled) {
                        await Geolocator.openLocationSettings();
                      } else {
                        await Geolocator.openAppSettings();
                      }
                      // didChangeAppLifecycleState will invalidate the provider
                      // automatically when the user returns.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.convoyGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    icon: Icon(Icons.settings_rounded,
                        color: Colors.black, size: 18.w),
                    label: Text(
                      isServiceDisabled
                          ? 'Enable Location'
                          : 'Open App Settings',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Retry link
                TextButton(
                  onPressed: () => ref.invalidate(locationStreamProvider),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.convoyBlue,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMembersSheet() {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final name = profile?.name ?? 'Host';
    final avatarColor = profile?.avatarColor ?? '#4CAF50';
    final color = _fromHex(avatarColor);
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'H';

    // Capture current dummy state snapshot for the sheet
    final dummySnapshot = List<DummyMember>.from(_dummyMembers);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          // Refresh sheet every 2s when in dev mode to update distances
          if (_useDummyRealtimeData && dummySnapshot.isNotEmpty) {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) setSheetState(() {});
            });
          }
          return Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Convoy Members',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    if (_useDummyRealtimeData) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.convoyAmber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.convoyAmber.withOpacity(0.4)),
                        ),
                        child: Text(
                          'DEV',
                          style: TextStyle(
                            color: AppColors.convoyAmber,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.h),
                // Host tile (always shown)
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
                // Dummy member tiles (shown when dev mode is active)
                if (_useDummyRealtimeData && dummySnapshot.isNotEmpty) ...[
                  Divider(color: AppColors.border, height: 1.h),
                  ...dummySnapshot.map((member) {
                    final distLabel = _routePoints.isNotEmpty
                        ? _memberDistanceLabel(member)
                        : 'Calculating...';
                    final statusColor = _routePoints.isNotEmpty
                        ? _memberStatusColor(member)
                        : Colors.grey;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: member.avatarColor,
                            child: Text(
                              member.avatarInitial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            member.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            distLabel,
                            style: TextStyle(color: statusColor),
                          ),
                          trailing: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Divider(color: AppColors.border, height: 1.h),
                      ],
                    );
                  }),
                ],
              ],
            ),
          );
        },
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

  Set<Marker> _buildMarkers(
      JourneyEntity journey, List<CheckpointEntity> checkpoints) {
    final markers = <Marker>{};
    if (journey.sourceLat != null && journey.sourceLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: LatLng(journey.sourceLat!, journey.sourceLng!),
          infoWindow:
              InfoWindow(title: 'Starting point: ${journey.sourceName}'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (journey.destinationLat != null && journey.destinationLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(journey.destinationLat!, journey.destinationLng!),
          infoWindow:
              InfoWindow(title: 'Destination: ${journey.destinationName}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    // Inject live-moving dummy member markers when dev mode is enabled
    if (_useDummyRealtimeData) {
      for (final member in _dummyMembers) {
        markers.add(
          Marker(
            markerId: MarkerId(member.id),
            position: member.currentPosition,
            infoWindow: InfoWindow(
              title: member.name,
              snippet:
                  _routePoints.isNotEmpty ? _memberDistanceLabel(member) : '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(member.markerHue),
          ),
        );
      }
    }
    // Inject checkpoints as markers on the map
    for (final cp in checkpoints) {
      double hue;
      switch (cp.type) {
        case 'fuel':
          hue = BitmapDescriptor.hueYellow;
          break;
        case 'rest':
          hue = BitmapDescriptor.hueGreen;
          break;
        default:
          hue = BitmapDescriptor.hueBlue; // meetup
      }
      markers.add(
        Marker(
          markerId: MarkerId('checkpoint_${cp.id}'),
          position: LatLng(cp.latitude, cp.longitude),
          infoWindow: InfoWindow(
            title: '${cp.name} (${cp.type.toUpperCase()})',
            snippet: 'Radius: ${cp.radius.round()}m',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationStreamProvider);
    final journeyAsync =
        ref.watch(watchJourneyDetailsProvider(widget.journeyId));
    final currentDeviceId = ref.watch(deviceIdProvider);
    final checkpointsAsync =
        ref.watch(watchCheckpointsProvider(widget.journeyId));
    final checkpoints = checkpointsAsync.valueOrNull ?? [];

    return Scaffold(
      body: journeyAsync.when(
        data: (journey) {
          if (journey == null) {
            return const Center(
              child: Text('Journey not found',
                  style: TextStyle(color: Colors.white)),
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
                          ? LatLng(
                              journey.destinationLat!, journey.destinationLng!)
                          : latLng,
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapType: MapType.normal,
                    polylines: _polylines,
                    markers: _buildMarkers(journey, checkpoints),
                    onLongPress: isHost
                        ? (latLng) => _showAddCheckpointDialog(latLng)
                        : null,
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
                error: (err, _) => _buildLocationErrorOverlay(err, journey),
              ),

              // 2. Custom header overlay — hidden when location error is shown
              //    so the error card buttons are not blocked.
              if (!locationAsync.hasError)
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  right: 20.w,
                  child: _buildTopOverlay(journey, isRouteConfigured, isHost),
                ),

              // 3. Setup Sheet or Live overlay — also hidden on location error.
              if (!locationAsync.hasError)
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
                                const SnackBar(
                                    content: Text(
                                        'Convoy route configured successfully!')),
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
                              border:
                                  Border.all(color: AppColors.border, width: 1.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 36.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                    color: AppColors.convoyAmber),
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
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 13.sp),
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
          child:
              Text('Error: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTopOverlay(
      JourneyEntity journey, bool isRouteConfigured, bool isHost) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bg0.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: isHost ? 'Cancel Journey' : 'Leave Journey',
            onPressed: () => _confirmCancelOrLeaveJourney(journey, isHost),
          ),
          SizedBox(width: 8.w),
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
                  !isRouteConfigured
                      ? 'Setting up Convoy...'
                      : (journey.status == JourneyStatus.paused
                          ? 'Convoy Paused • ${_useDummyRealtimeData && _dummyMembers.isNotEmpty ? _dummyMembers.length + 1 : 1} members online'
                          : 'Convoy Active • ${_useDummyRealtimeData && _dummyMembers.isNotEmpty ? _dummyMembers.length + 1 : 1} members online'),
                  style: TextStyle(
                    color: !isRouteConfigured
                        ? AppColors.convoyAmber
                        : (journey.status == JourneyStatus.paused
                            ? AppColors.convoyAmber
                            : AppColors.convoyGreen),
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
          _buildBottomAction(Icons.flag, 'Checkpoints',
              onTap: () => _showCheckpointsSheet(journey)),
          _buildBottomAction(Icons.qr_code, 'Invite',
              onTap: () => _showInviteSheet(journey.name, journey.passCode)),
          _buildBottomAction(Icons.my_location, 'Recenter', onTap: _recenter),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24.w),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
