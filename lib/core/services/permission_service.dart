import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationAlways.request();
    if (status.isGranted) return true;
    final whenInUse = await Permission.locationWhenInUse.request();
    return whenInUse.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> requestBatteryOptimizationIgnore() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }
}
