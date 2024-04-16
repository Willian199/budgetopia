import 'package:permission_handler/permission_handler.dart';

class Permissao {
  static const _validStatus = [PermissionStatus.granted, PermissionStatus.limited];
  static Future<bool> requestCustomPermission(List<Permission> permission) async {
    final Map<Permission, PermissionStatus> statuses = await permission.request();

    for (final PermissionStatus value in statuses.values) {
      if (!_validStatus.contains(value)) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> requestCamera() async {
    return checkPermission(Permission.camera);
  }

  static Future<bool> requestGaleria() async {
    return checkPermission(Permission.photos);
  }

  static Future<bool> checkPermission(Permission permission) async {
    final PermissionStatus permissionStatus = await permission.status;

    if (!_validStatus.contains(permissionStatus)) {
      return requestCustomPermission([permission]);
    }

    return true;
  }
}
