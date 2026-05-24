import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdentityService {
  static const _deviceIdKey = 'device_id';

  final SharedPreferences _prefs;
  
  DeviceIdentityService(this._prefs);

  String getDeviceId() {
    String? id = _prefs.getString(_deviceIdKey);
    if (id == null) {
      id = const Uuid().v4();
      _prefs.setString(_deviceIdKey, id);
    }
    return id;
  }

  bool hasCompletedOnboarding() {
    return _prefs.getBool('has_completed_onboarding') ?? false;
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool('has_completed_onboarding', true);
  }
}
