import 'package:root_check_flutter/root_check_flutter.dart';

class RootChecker {
  static Future<bool> isDeviceCompromised({bool allowEmulator = false}) async {
    final rooted = await RootCheckFlutter.isDeviceRooted;
    final virtual = await RootCheckFlutter.isVirtualDevice;

    if (allowEmulator) return rooted;
    return rooted || virtual;
  }

  static Future<void> enforce({bool allowEmulator = false}) async {
    final compromised = await isDeviceCompromised(allowEmulator: allowEmulator);
    if (compromised) {
      throw Exception('Device security violation detected');
    }
  }
}
