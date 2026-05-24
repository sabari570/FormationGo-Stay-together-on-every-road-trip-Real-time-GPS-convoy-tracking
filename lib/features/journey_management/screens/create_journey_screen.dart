import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/create_journey_provider.dart';

class CreateJourneyScreen extends ConsumerStatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  ConsumerState<CreateJourneyScreen> createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends ConsumerState<CreateJourneyScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a journey name')),
      );
      return;
    }

    await ref.read(createJourneyProvider.notifier).createJourney(name);
    
    final state = ref.read(createJourneyProvider);
    if (state.hasValue && state.value != null) {
      if (mounted) {
        // Go back to home, then push to the new journey dashboard
        context.go('/');
        context.push('/journey/${state.value!.id}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createJourneyProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Journey'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start a new convoy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Give your journey a name so others can easily identify it.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Journey Name (e.g. Weekend Ride)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.convoyGreen),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.convoyGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: state.isLoading 
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        'Create & Invite',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
