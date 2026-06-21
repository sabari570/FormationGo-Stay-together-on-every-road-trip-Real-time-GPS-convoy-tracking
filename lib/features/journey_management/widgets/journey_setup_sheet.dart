import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../chatbot/providers/chatbot_provider.dart';
import 'place_search_sheet.dart';
import '../providers/place_search_provider.dart';
import '../services/current_location_service.dart';

class JourneySetupSheet extends ConsumerStatefulWidget {
  final String journeyId;
  final VoidCallback onJourneyStarted;

  const JourneySetupSheet({
    super.key,
    required this.journeyId,
    required this.onJourneyStarted,
  });

  @override
  ConsumerState<JourneySetupSheet> createState() => _JourneySetupSheetState();
}

class _JourneySetupSheetState extends ConsumerState<JourneySetupSheet> {
  String _sourceName = 'Current Location';
  double? _sourceLat;
  double? _sourceLng;

  String? _destinationName;
  double? _destinationLat;
  double? _destinationLng;

  bool _isLoading = false;
  bool _isFetchingLocation = false;

  final _currentLocationService = CurrentLocationService();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationBaseline();
  }

  Future<void> _fetchCurrentLocationBaseline() async {
    try {
      final place = await _currentLocationService.getCurrentPlace();
      if (mounted) {
        setState(() {
          _sourceName = place.name;
          _sourceLat = place.latitude;
          _sourceLng = place.longitude;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sourceName = 'Choose starting point';
        });
      }
    }
  }

  Future<void> _setCurrentLocation({required bool isSource}) async {
    setState(() => _isFetchingLocation = true);
    try {
      final place = await _currentLocationService.getCurrentPlace();
      if (!mounted) return;
      setState(() {
        if (isSource) {
          _sourceName = place.name;
          _sourceLat = place.latitude;
          _sourceLng = place.longitude;
        } else {
          _destinationName = place.name;
          _destinationLat = place.latitude;
          _destinationLng = place.longitude;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get current location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Future<void> _pickSource() async {
    final result = await showModalBottomSheet<PlaceDetails>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PlaceSearchSheet(title: 'Starting Point'),
    );

    if (result != null && mounted) {
      setState(() {
        _sourceName = result.name;
        _sourceLat = result.latitude;
        _sourceLng = result.longitude;
      });
    }
  }

  Future<void> _pickDestination() async {
    final result = await showModalBottomSheet<PlaceDetails>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PlaceSearchSheet(title: 'Destination'),
    );

    if (result != null && mounted) {
      setState(() {
        _destinationName = result.name;
        _destinationLat = result.latitude;
        _destinationLng = result.longitude;
      });
    }
  }

  Future<void> _startJourney() async {
    if (_sourceLat == null || _sourceLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid starting point.')),
      );
      return;
    }

    if (_destinationLat == null || _destinationLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(journeyRepositoryProvider);
      final journey = await repo.getJourney(widget.journeyId);

      if (journey != null) {
        final updatedJourney = journey.copyWith(
          sourceName: _sourceName,
          sourceLat: _sourceLat,
          sourceLng: _sourceLng,
          destinationName: _destinationName,
          destinationLat: _destinationLat,
          destinationLng: _destinationLng,
          updatedAt: DateTime.now(),
        );
        await repo.saveJourney(updatedJourney);

        ref
            .read(routePoiIndexingStatusProvider(widget.journeyId).notifier)
            .startIndexing();

        widget.onJourneyStarted();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save journey setup: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
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
          SizedBox(height: 16.h),
          Text(
            'Plan Your Convoy',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Select the source and destination for your group journey.',
            style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // Source Input Card
          _buildLocationPickerCard(
            context,
            label: 'STARTING POINT',
            value: _sourceName,
            icon: Icons.my_location,
            iconColor: AppColors.convoyGreen,
            onTap: _pickSource,
            onUseCurrentLocation: () => _setCurrentLocation(isSource: true),
          ),
          SizedBox(height: 16.h),

          // Destination Input Card
          _buildLocationPickerCard(
            context,
            label: 'DESTINATION',
            value: _destinationName ?? 'Where are we going?',
            valueColor:
                _destinationName == null ? Colors.grey[500] : Colors.white,
            icon: Icons.place,
            iconColor: AppColors.convoyRed,
            onTap: _pickDestination,
            onUseCurrentLocation: () => _setCurrentLocation(isSource: false),
          ),
          SizedBox(height: 28.h),

          // Start Button
          ElevatedButton(
            onPressed:
                (_isLoading || _isFetchingLocation) ? null : _startJourney,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.convoyBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 4,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Start Convoy Journey',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPickerCard(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    VoidCallback? onUseCurrentLocation,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24.w),
          SizedBox(width: 14.w),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.convoyNeutral,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (onUseCurrentLocation != null)
            IconButton(
              tooltip: 'Use current location',
              onPressed: _isFetchingLocation ? null : onUseCurrentLocation,
              icon: Icon(
                Icons.gps_fixed,
                color: iconColor,
                size: 20.w,
              ),
            ),
          GestureDetector(
            onTap: onTap,
            child:
                Icon(Icons.chevron_right, color: Colors.grey[500], size: 20.w),
          ),
        ],
      ),
    );
  }
}
