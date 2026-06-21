import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/checkpoint.dart';
import '../../../domain/entities/journey_member.dart';
import '../../../domain/entities/member_location.dart';
import '../../tracking/providers/location_provider.dart';
import '../../tracking/providers/live_location_provider.dart';
import '../../tracking/services/directions_service.dart';
import '../../home/providers/home_provider.dart';
import '../providers/journey_details_provider.dart';
import '../providers/place_search_provider.dart';
import '../widgets/journey_setup_sheet.dart';
import '../widgets/invite_sheet.dart';
import '../widgets/place_search_sheet.dart';
import '../services/current_location_service.dart';
import 'package:geolocator/geolocator.dart';
import '../../tracking/widgets/convoy_map.dart';
import '../../chatbot/widgets/chatbot_fab.dart';
import '../../chatbot/providers/chatbot_provider.dart';

class JourneyDashboardScreen extends ConsumerStatefulWidget {
  final String journeyId;

  const JourneyDashboardScreen({super.key, required this.journeyId});

  @override
  ConsumerState<JourneyDashboardScreen> createState() =>
      _JourneyDashboardScreenState();
}

class _JourneyDashboardScreenState extends ConsumerState<JourneyDashboardScreen>
    with WidgetsBindingObserver {
  MapController? _mapController;
  List<LatLng> _routePoints = [];
  bool _fetchingRoute = false;
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the user returns from the device Settings page, re-check location.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(locationStreamProvider);
    }
  }

  void _fetchRoute(double startLat, double startLng, double destLat,
      double destLng, JourneyEntity journey) async {
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
        if (points.isNotEmpty) {
          _fitRouteBounds();
        }

        ref.read(routePipelineServiceProvider).initializeForJourney(
              journey,
              routeCoordinates: points,
            );
      }
    } catch (e) {
      if (mounted) {
        ref.read(routePipelineServiceProvider).initializeForJourney(journey);
      }
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
    fitMapToRoute(_mapController!, _routePoints, padding: 80.r);
  }

  void _recenter() {
    if (_mapController != null && _currentLatLng != null) {
      _mapController!.move(_currentLatLng!, 15);
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
                                                .deleteCheckpoint(
                                                    journey.id, cp.id);
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
                leading: Icon(Icons.my_location,
                    color: AppColors.convoyGreen, size: 22.w),
                title: const Text('Use My Current Location',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  'Add a checkpoint at your live GPS position',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12.sp),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _addCheckpointAtCurrentLocation();
                },
              ),
              Divider(color: AppColors.border, height: 1.h),
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
                    color: AppColors.convoyAmber, size: 22.w),
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

  Future<void> _addCheckpointAtCurrentLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final locationService = CurrentLocationService();
      final PlaceDetails place;

      if (_currentLatLng != null) {
        place = await locationService.placeFromLatLng(_currentLatLng!);
      } else {
        place = await locationService.getCurrentPlace();
      }

      if (!mounted) return;

      _showAddCheckpointDialog(
        LatLng(place.latitude, place.longitude),
        defaultName: place.name,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not get current location: $e')),
      );
    }
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
        ConvoyMap(
          initialCenter: LatLng(fallbackLat, fallbackLng),
          initialZoom: 6,
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

  String _locationStatusLabel(MemberLocationEntity? location) {
    if (location == null) return 'Waiting for GPS...';
    final age = DateTime.now().difference(location.timestamp);
    if (age > const Duration(minutes: 2)) {
      return 'Last seen ${formatTimeAgo(age)}';
    }
    if (location.speed > 1)
      return 'Moving • ${(location.speed * 3.6).toStringAsFixed(0)} km/h';
    return 'Active - Tracking GPS';
  }

  Color _locationStatusColor(MemberLocationEntity? location) {
    if (location == null) return Colors.grey;
    final age = DateTime.now().difference(location.timestamp);
    if (age > const Duration(minutes: 2)) return AppColors.convoyAmber;
    return Colors.greenAccent;
  }

  void _showMembersSheet(String journeyId, String currentDeviceId) {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final name = profile?.name ?? 'You';
    final avatarColor = profile?.avatarColor ?? '#4CAF50';
    final color = _fromHex(avatarColor);
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'Y';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final members =
              ref.watch(journeyMembersProvider(journeyId)).valueOrNull ?? [];
          final locations =
              ref.watch(memberLocationsProvider(journeyId)).valueOrNull ?? [];
          final locationByDevice = {
            for (final loc in locations) loc.deviceId: loc,
          };

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
                Text(
                  'Convoy Members',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                SizedBox(height: 16.h),
                ...members.map((member) {
                  final isCurrent = member.deviceId == currentDeviceId;
                  final location = locationByDevice[member.deviceId];
                  final memberColor = _fromHex(member.avatarColor);
                  final memberInitial = member.name.isNotEmpty
                      ? member.name.substring(0, 1).toUpperCase()
                      : '?';
                  final statusColor = _locationStatusColor(location);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: memberColor,
                          child: Text(
                            memberInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          isCurrent ? '${member.name} (You)' : member.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          _locationStatusLabel(location),
                          style: TextStyle(color: statusColor),
                        ),
                        trailing: member.role == 'host'
                            ? const Icon(Icons.star, color: Colors.amber)
                            : Container(
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
                if (members.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: ListTile(
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
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<ConvoyMapMarker> _buildMapMarkers(
    JourneyEntity journey,
    List<CheckpointEntity> checkpoints,
    List<JourneyMemberEntity> members,
    List<MemberLocationEntity> locations,
    String currentDeviceId,
  ) {
    final markers = <ConvoyMapMarker>[];
    final locationByDevice = {
      for (final loc in locations) loc.deviceId: loc,
    };

    if (journey.sourceLat != null && journey.sourceLng != null) {
      markers.add(
        ConvoyMapMarker(
          id: 'source',
          position: LatLng(journey.sourceLat!, journey.sourceLng!),
          color: Colors.green,
          title: 'Starting point: ${journey.sourceName}',
          icon: Icons.trip_origin,
        ),
      );
    }
    if (journey.destinationLat != null && journey.destinationLng != null) {
      markers.add(
        ConvoyMapMarker(
          id: 'destination',
          position: LatLng(journey.destinationLat!, journey.destinationLng!),
          color: Colors.red,
          title: 'Destination: ${journey.destinationName}',
          icon: Icons.flag,
        ),
      );
    }

    for (final member in members) {
      if (member.deviceId == currentDeviceId) continue;
      final location = locationByDevice[member.deviceId];
      if (location == null) continue;

      markers.add(
        ConvoyMapMarker(
          id: member.deviceId,
          position: LatLng(location.latitude, location.longitude),
          color: _fromHex(member.avatarColor),
          title: member.name,
          subtitle: _locationStatusLabel(location),
          icon: Icons.person_pin_circle,
        ),
      );
    }

    for (final cp in checkpoints) {
      Color color;
      IconData icon;
      switch (cp.type) {
        case 'fuel':
          color = AppColors.convoyAmber;
          icon = Icons.local_gas_station;
          break;
        case 'rest':
          color = AppColors.convoyGreen;
          icon = Icons.restaurant;
          break;
        default:
          color = AppColors.convoyBlue;
          icon = Icons.people;
      }
      markers.add(
        ConvoyMapMarker(
          id: 'checkpoint_${cp.id}',
          position: LatLng(cp.latitude, cp.longitude),
          color: color,
          title: '${cp.name} (${cp.type.toUpperCase()})',
          subtitle: 'Radius: ${cp.radius.round()}m',
          icon: icon,
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
    final members =
        ref.watch(journeyMembersProvider(widget.journeyId)).valueOrNull ?? [];
    final locations =
        ref.watch(memberLocationsProvider(widget.journeyId)).valueOrNull ?? [];
    final memberCount = members.isEmpty ? 1 : members.length;

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
            ref.watch(liveLocationSyncProvider(widget.journeyId));
            _fetchRoute(
              journey.sourceLat!,
              journey.sourceLng!,
              journey.destinationLat!,
              journey.destinationLng!,
              journey,
            );
          }

          return Stack(
            children: [
              locationAsync.when(
                data: (position) {
                  final latLng = LatLng(position.latitude, position.longitude);
                  _currentLatLng = latLng;

                  return ConvoyMap(
                    initialCenter: isRouteConfigured
                        ? LatLng(
                            journey.destinationLat!, journey.destinationLng!)
                        : latLng,
                    initialZoom: 14,
                    routePoints: _routePoints,
                    markers: _buildMapMarkers(
                      journey,
                      checkpoints,
                      members,
                      locations,
                      currentDeviceId,
                    ),
                    currentPosition: latLng,
                    onLongPress: isHost ? _showAddCheckpointDialog : null,
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
                  child: _buildTopOverlay(
                    journey,
                    isRouteConfigured,
                    isHost,
                    memberCount,
                  ),
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
                              border: Border.all(
                                  color: AppColors.border, width: 1.w),
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
                    child: _buildBottomOverlay(journey, currentDeviceId),
                  ),

              if (isRouteConfigured)
                Positioned(
                  bottom: 100.h,
                  right: 20.w,
                  child: ChatbotFab(journeyId: journey.id),
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
    JourneyEntity journey,
    bool isRouteConfigured,
    bool isHost,
    int memberCount,
  ) {
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
                          ? 'Convoy Paused • $memberCount members online'
                          : 'Convoy Active • $memberCount members online'),
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

  Widget _buildBottomOverlay(JourneyEntity journey, String currentDeviceId) {
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
          _buildBottomAction(Icons.people, 'Members',
              onTap: () => _showMembersSheet(journey.id, currentDeviceId)),
          _buildBottomAction(Icons.chat_bubble_outline, 'Chat',
              onTap: () => context.push('/journey/${journey.id}/group-chat')),
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
