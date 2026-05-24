import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/place_search_provider.dart';

class PlaceSearchSheet extends ConsumerStatefulWidget {
  final String title;

  const PlaceSearchSheet({
    super.key,
    required this.title,
  });

  @override
  ConsumerState<PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends ConsumerState<PlaceSearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  bool _isFetchingDetails = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(placeSearchProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(placeSearchProvider);

    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColors.bg0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for place...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
              prefixIcon:
                  Icon(Icons.search, color: AppColors.convoyBlue, size: 22.w),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: () {
                        _controller.clear();
                        ref.read(placeSearchProvider.notifier).search('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.bg1,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: AppColors.convoyBlue),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          if (_isFetchingDetails)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.convoyBlue),
                    SizedBox(height: 12),
                    Text('Fetching place details...',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: searchState.when(
                data: (predictions) {
                  if (predictions.isEmpty) {
                    return Center(
                      child: Text(
                        _controller.text.isEmpty
                            ? 'Start typing to search'
                            : 'No results found',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: predictions.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.border.withOpacity(0.5),
                      height: 1.h,
                    ),
                    itemBuilder: (_, index) {
                      final pred = predictions[index];
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: AppColors.bg1,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(Icons.place,
                              color: AppColors.convoyBlue, size: 20.w),
                        ),
                        title: Text(
                          pred.description,
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                        onTap: () async {
                          setState(() => _isFetchingDetails = true);
                          try {
                            final details = await ref
                                .read(placeSearchProvider.notifier)
                                .getDetails(pred.placeId);
                            if (mounted) {
                              Navigator.of(this.context).pop(details);
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isFetchingDetails = false);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Could not fetch place details: $e'),
                                  backgroundColor: Colors.red[800],
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.convoyBlue),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Error searching places: $err',
                    style: const TextStyle(color: AppColors.convoyRed),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
