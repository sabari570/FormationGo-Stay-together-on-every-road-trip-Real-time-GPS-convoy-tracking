import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final journeysAsync = ref.watch(recentJourneysProvider);

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
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'Ready to ride?',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[400],
                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading profile', style: TextStyle(color: Colors.white)),
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
              SizedBox(height: 40.h),
              Text(
                'Recent Journeys',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: journeysAsync.when(
                  data: (journeys) {
                    if (journeys.isEmpty) {
                      return Center(
                        child: Text(
                          'No recent journeys.',
                          style: TextStyle(color: Colors.grey[500]),
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
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              context.push('/journey/${journey.id}');
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Failed to load journeys')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
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
