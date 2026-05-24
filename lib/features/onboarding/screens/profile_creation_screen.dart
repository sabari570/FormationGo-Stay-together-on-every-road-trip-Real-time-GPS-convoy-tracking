import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/profile_creation_provider.dart';

class ProfileCreationScreen extends ConsumerStatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  ConsumerState<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends ConsumerState<ProfileCreationScreen> {
  final _nameController = TextEditingController();
  final List<String> _colors = [
    '#00E676', '#FFC400', '#FF3D00', '#2979FF', '#AA00FF', '#FF4081', '#00E5FF'
  ];
  String _selectedColor = '#00E676';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    await ref.read(profileCreationProvider.notifier).createProfile(
      name: name,
      avatarColor: _selectedColor,
    );
    
    if (ref.read(profileCreationProvider).hasError == false) {
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileCreationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who\'s riding?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'This helps other riders identify you in the convoy.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              SizedBox(height: 32.h),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 100.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: _fromHex(_selectedColor),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _nameController.text.isNotEmpty 
                        ? _nameController.text.substring(0, 1).toUpperCase() 
                        : '?',
                      style: TextStyle(
                        fontSize: 40.sp, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Your Name or Rider Alias',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.convoyGreen),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Choose a marker color',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: _fromHex(color),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      ),
                    ),
                  );
                }).toList(),
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
                        'Complete Setup',
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
