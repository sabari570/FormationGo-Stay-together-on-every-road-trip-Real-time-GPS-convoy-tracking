import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> _confirmDeleteJourney(
      BuildContext context, WidgetRef ref, JourneyEntity journey) async {
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
            'Delete Journey',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${journey.name}"? This action cannot be undone.',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
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
                'Delete',
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
      final deviceId = ref.read(deviceIdProvider);
      await ref.read(journeyRepositoryProvider).deleteJourney(
            journey.id,
            hostDeviceId: deviceId,
          );
    }
  }

  Widget _buildJourneyList({
    required AsyncValue<List<JourneyEntity>> journeysAsync,
    required String emptyMessage,
    required bool showDelete,
  }) {
    return journeysAsync.when(
      data: (journeys) {
        if (journeys.isEmpty) {
          return Center(
            child: Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          itemCount: journeys.length,
          itemBuilder: (context, index) {
            final journey = journeys[index];
            return Card(
              color: AppColors.bg1,
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                title: Text(
                  journey.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  journey.createdAt.toString().split(' ')[0],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDelete)
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () =>
                            _confirmDeleteJourney(context, ref, journey),
                      ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  context.push('/journey/${journey.id}');
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          const Center(child: Text('Failed to load journeys')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final createdAsync = ref.watch(createdJourneysProvider);
    final joinedAsync = ref.watch(joinedJourneysProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              profileAsync.when(
                data: (profile) {
                  if (profile == null) return const SizedBox();
                  return Row(
                    children: [
                      Container(
                        height: 50.w,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: _fromHex(profile.avatarColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            profile.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${profile.name}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'Ready to ride?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[400],
                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading profile',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 40.h),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Create\nJourney',
                      icon: Icons.add_road,
                      color: AppColors.convoyGreen,
                      onTap: () {
                        context.push('/create-journey');
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Join\nJourney',
                      icon: Icons.qr_code_scanner,
                      color: AppColors.convoyAmber,
                      onTap: () {
                        context.push('/join-journey');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.convoyGreen,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[500],
                tabs: const [
                  Tab(text: 'My Tours'),
                  Tab(text: 'Joined'),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildJourneyList(
                      journeysAsync: createdAsync,
                      emptyMessage: 'No tours created yet.\nTap Create Journey to start one.',
                      showDelete: true,
                    ),
                    _buildJourneyList(
                      journeysAsync: joinedAsync,
                      emptyMessage: 'No joined tours yet.\nJoin a convoy with a passcode or QR code.',
                      showDelete: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32.w),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
