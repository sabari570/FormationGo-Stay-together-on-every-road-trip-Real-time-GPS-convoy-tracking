import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_identity_service.dart';

part 'device_identity_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('sharedPreferences must be overridden in ProviderScope');
}

@Riverpod(keepAlive: true)
DeviceIdentityService deviceIdentityService(DeviceIdentityServiceRef ref) {
  return DeviceIdentityService(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
String deviceId(DeviceIdRef ref) {
  return ref.watch(deviceIdentityServiceProvider).getDeviceId();
}
