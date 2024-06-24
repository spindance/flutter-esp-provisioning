import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';

/// The main/public class for the ESP Provisioning plugin. Provides access to all plugin methods.
class EspProvisioning {
  /// The private singleton instance of the [EspProvisioningPlatform] class.
  EspProvisioningPlatform get _espPlatform => EspProvisioningPlatform.instance;

  /// Returns the name of the current platform.
  String get platformName => _espPlatform.platformName;

  /// Scans for BLE devices.
  Future<List<String>> scanForDevices(String? deviceNamePrefix) => _espPlatform.scanForEspDevices(deviceNamePrefix);

  /// Stops scanning for BLE devices.
  Future<void> stopScan() => _espPlatform.stopEspDeviceScan();
}
