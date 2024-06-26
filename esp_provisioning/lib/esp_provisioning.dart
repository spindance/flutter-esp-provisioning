import 'dart:async';

import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';

import 'esp_provisioning.dart';

export 'src/esp_ble_device.dart';
export 'src/esp_wifi_access_point.dart';
export 'src/esp_wifi_access_point_security.dart';

/// The main/public class for the ESP Provisioning plugin. Provides access to all plugin methods.
class EspProvisioning {
  /// The private singleton instance of the [EspProvisioningPlatform] class.
  EspProvisioningPlatform get _espPlatform => EspProvisioningPlatform.instance;

  /// Returns the name of the current platform.
  String get platformName => _espPlatform.platformName;

  /// Scans for BLE devices.
  Future<List<EspBleDevice>> scanForDevices(String? deviceNamePrefix) async {
    final deviceNames = await _espPlatform.scanForEspDevices(deviceNamePrefix);
    return deviceNames.map((deviceName) => EspBleDevice(name: deviceName)).toList();
  }

  /// Stops scanning for BLE devices.
  Future<void> stopScan() => _espPlatform.stopEspDeviceScan();

  /// Connects to a BLE device with the specified name. The [proofOfPossession] is used to authenticate the device, and
  /// is optional because the device can optionally support that feature. The [provisioningServiceUuid] is the UUID of
  /// BLE service that the device is using for provisioning, which is implementation-specific on the device.
  Future<void> connect(String deviceName, String provisioningServiceUuid, String? proofOfPossession) async {
    await _espPlatform.connectDevice(deviceName, provisioningServiceUuid, proofOfPossession);
  }

  /// Disconnects from the BLE device with the specified [deviceName].
  Future<void> disconnect(String deviceName) => _espPlatform.disconnectDevice(deviceName);

  /// Gets the Wi-Fi access points visible to the device with [deviceName], sorted by their SSID.
  Future<List<EspWifiAccessPoint>> getAccessPoints(String deviceName) async {
    // final timer = Timer(const Duration(seconds: 10), () {
    //   throw TimeoutException('Failed to get access points within 10 seconds.');
    // });
    // final accessPoints = (await _espPlatform.getEspAccessPoints(deviceName)).map(EspWifiAccessPoint.fromMap).toList();
    // timer.cancel();
    // return accessPoints;

    final ssids = await _espPlatform.getEspAccessPoints(deviceName).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('Failed to get access points within 10 seconds.'),
    );
    ssids.sort();
    return ssids
      .map( (ssid) => EspWifiAccessPoint(channel: 0, rssi: 0, security: EspWifiAccessPointSecurity.unknown, ssid: ssid))
      .toList();
  }

  /// Sets the Wi-Fi access point with the specified [ssid] and [password] on the device with [deviceName]. If this
  /// operation is successful, the device automatically disconnects.
  Future<void> setAccessPoint(String deviceName, String ssid, String password) =>
      _espPlatform.setEspAccessPoint(deviceName, ssid, password);
}
