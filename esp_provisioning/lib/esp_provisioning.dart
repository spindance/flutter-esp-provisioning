import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';

import 'esp_provisioning.dart';

export 'src/esp_ble_device.dart';
export 'src/esp_wifi_access_point.dart';
export 'src/esp_wifi_access_point_security.dart';

/// The main/public class for the ESP Provisioning plugin. Provides access to all plugin methods.
class EspProvisioning {
  /// Creates a new instance of [EspProvisioning] with the specified [_provisioningServiceUuid], which is the UUID of
  /// the BLE service that the device provides for Wi-Fi provisioning, which is implementation-specific on the device.
  EspProvisioning(this._provisioningServiceUuid);

  final String _provisioningServiceUuid;

  /// The default response timeout for all operations, in seconds.
  static const defaultResponseTimeoutSec = 10;

  /// The private singleton instance of the [EspProvisioningPlatform] class.
  EspProvisioningPlatform get _espPlatform => EspProvisioningPlatform.instance;

  /// Returns the name of the current platform.
  String get platformName => _espPlatform.platformName;

  /// Scans for BLE devices.
  Future<List<EspBleDevice>> scanForDevices(String? deviceNamePrefix) async {
    final deviceJsonStrings = await _espPlatform.scanForEspDevices(deviceNamePrefix);
    final devicesJson = deviceJsonStrings.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    return devicesJson.map(EspBleDevice.fromJson).toList();
  }

  /// Stops scanning for BLE devices.
  Future<void> stopScan() => _espPlatform.stopEspDeviceScan();

  /// Connects to a BLE device with the specified name. The [proofOfPossession] is used to authenticate the device, and
  /// is optional because the device can optionally support that feature.
  Future<void> connect(String deviceName, String? proofOfPossession) =>
      _espPlatform.connectDevice(deviceName, _provisioningServiceUuid, proofOfPossession);

  /// Disconnects from the BLE device with the specified [deviceName].
  Future<void> disconnect(String deviceName) => _espPlatform.disconnectDevice(deviceName);

  /// Gets the Wi-Fi access points visible to the device with [deviceName], sorted by their SSID. [responseTimeoutSec]
  /// is optional and defaults to [defaultResponseTimeoutSec].
  Future<List<EspWifiAccessPoint>> getAccessPoints(
    String deviceName, [
    int responseTimeoutSec = defaultResponseTimeoutSec,
  ]) async {
    // Get the access points as JSON strings.
    final accessPointJsonStrings = await _espPlatform.getEspAccessPoints(deviceName).timeout(
          Duration(seconds: responseTimeoutSec),
          onTimeout: () => throw TimeoutException('Failed to get access points within 10 seconds.'),
        );

    // Deserialize the JSON strings into maps.
    final accessPointMaps = accessPointJsonStrings.map((e) => json.decode(e) as Map<String, dynamic>).toList();

    // Convert the maps into EspWifiAccessPoint objects and return the sorted by SSID.
    final accessPoints = accessPointMaps.map(EspWifiAccessPoint.fromJson).toList()
      ..sort((a, b) => a.ssid.compareTo(b.ssid));

    return accessPoints;
  }

  /// Sets the Wi-Fi access point with the specified [ssid] and [password] on the device with [deviceName]. If this
  /// operation is successful, the device automatically disconnects. [responseTimeoutSec] is optional and defaults to
  /// [defaultResponseTimeoutSec].
  Future<void> setAccessPoint(
    String deviceName,
    String ssid,
    String password, [
    int responseTimeoutSec = defaultResponseTimeoutSec,
  ]) =>
      _espPlatform.setEspAccessPoint(deviceName, ssid, password).timeout(
            Duration(seconds: responseTimeoutSec),
            onTimeout: () => throw TimeoutException('Failed to set access point within 10 seconds.'),
          );

  /// Sends the Base64 encoded string [base64Data] to the specified [endpoint] on the device with [deviceName],
  /// returning a Base64 encoded response string.  [responseTimeoutSec] is optional and defaults to
  /// [defaultResponseTimeoutSec].
  Future<String> sendDataToEndpoint(
    String deviceName,
    String endpoint,
    String base64Data, [
    int responseTimeoutSec = defaultResponseTimeoutSec,
  ]) =>
      _espPlatform.sendData(deviceName, endpoint, base64Data).timeout(
            Duration(seconds: responseTimeoutSec),
            onTimeout: () => throw TimeoutException('Failed to send data within 10 seconds.'),
          );

  Future<Uint8List> sendBytesToEndpoint(
    String deviceName,
    String endpoint,
    Uint8List bytes, [
    int responseTimeoutSec = defaultResponseTimeoutSec,
  ]) =>
      _espPlatform.sendBytes(deviceName, endpoint, bytes).timeout(
            Duration(seconds: responseTimeoutSec),
            onTimeout: () => throw TimeoutException('Failed to send data within 10 seconds.'),
          );
}
