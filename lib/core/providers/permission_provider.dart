import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/permission_service.dart';

part 'permission_provider.g.dart';

@riverpod
PermissionService permissionService(PermissionServiceRef ref) {
  return PermissionService();
}
