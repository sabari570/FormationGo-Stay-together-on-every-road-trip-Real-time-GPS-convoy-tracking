import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/join_journey_provider.dart';

class JoinJourneyScreen extends ConsumerStatefulWidget {
  const JoinJourneyScreen({super.key});

  @override
  ConsumerState<JoinJourneyScreen> createState() => _JoinJourneyScreenState();
}

class _JoinJourneyScreenState extends ConsumerState<JoinJourneyScreen> {
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit PIN')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final journey = await ref
          .read(joinJourneyProvider.notifier)
          .joinJourney(pin);

      if (journey != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined convoy: ${journey.name}!')),
        );
        context.go('/journey/${journey.id}');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not join journey. Check passcode.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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

  void _simulateQRScan() {
    // Show a premium mock QR scanner dialog for testing/demo
    showDialog(
      context: context,
      builder: (context) {
        final mockController = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.bg1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: const BorderSide(color: AppColors.border),
          ),
          title: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: AppColors.convoyBlue, size: 24.w),
              SizedBox(width: 10.w),
              Text(
                'Scan QR Code',
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the passcode from the QR code (simulation):',
                style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: mockController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(color: Colors.white, letterSpacing: 4),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '123456',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: AppColors.bg0,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.convoyBlue),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                final pin = mockController.text.trim();
                Navigator.of(context).pop();
                if (pin.length == 6) {
                  _pinController.text = pin;
                  _submit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.convoyBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              child: const Text('Scan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Journey'),
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
                'Enter PIN',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Ask the host for the 6-digit passcode to join the convoy.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 16.w,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "000000",
                  hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 16.w),
                  filled: true,
                  fillColor: AppColors.bg1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: AppColors.convoyAmber),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: OutlinedButton.icon(
                  onPressed: _simulateQRScan,
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    'Scan QR Code',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.convoyAmber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Join Convoy',
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
