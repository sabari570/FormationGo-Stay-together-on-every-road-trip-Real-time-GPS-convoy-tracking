import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/join_qr_codec.dart';
import '../providers/join_journey_provider.dart';

class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _ensureCameraPermission();
  }

  Future<void> _ensureCameraPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _permissionDenied = !status.isGranted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final passCode = JoinQrCodec.parseJoinQr(raw);
    if (passCode == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final journey =
          await ref.read(joinJourneyProvider.notifier).joinJourney(passCode);

      if (!mounted) return;

      if (journey != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined convoy: ${journey.name}!')),
        );
        context.go('/journey/${journey.id}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not join journey. Check the QR code.'),
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: AppColors.bg1,
        foregroundColor: Colors.white,
      ),
      body: _permissionDenied
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_photography,
                      size: 64.w,
                      color: AppColors.convoyAmber,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Camera permission is required to scan QR codes.',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: openAppSettings,
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _handleBarcode,
                ),
                Center(
                  child: Container(
                    width: 240.w,
                    height: 240.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.convoyGreen,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.convoyGreen,
                      ),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 32.h,
                  child: Text(
                    'Point at the host\'s invite QR code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
